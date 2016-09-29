class ImportSenjuScriptJob < ApplicationJob
  queue_as :default

  WORK_DIR="work/jar"

  def perform(*args)
    @inputJar = args[0]

    extrace_jar()

    import_env
    import_job
    import_triger
    import_net
  end

  def import_object(path)
      File::readable?(path) or raise "Failed to open #{path}"

      f = File.open(path, "r", external_encoding: Encoding::SJIS)
      f.each_line do |line|
          yield line.split /\t/
      end
  end

  def extrace_jar
      system "rm -rf #{WORK_DIR}/*"
      system "cd #{WORK_DIR} && jar -xf #{File::absolute_path(@inputJar)}" or raise "Failed to extrace #{@inputJar.path}.........."
  end

  def import_env
      SenjuEnv.delete_all

      import_object "#{WORK_DIR}/動作環境.txt" do |items|
          e = SenjuEnv.new(name: items[SenjuEnv::NAME],
                           hostName: items[SenjuEnv::HOSTNAME],
                           logonUser: items[SenjuEnv::LOGONUSER])
          e.save
      end
  end


  def import_job
      SenjuJob.delete_all

      import_object "#{WORK_DIR}/ジョブ.txt" do |items|
          e = SenjuJob.new(name: items[SenjuJob::NAME],
                           description: items[SenjuJob::DESC],
                           command: items[SenjuJob::CMD],
                           expected: items[SenjuJob::EXPECTED].to_i)
          if items[SenjuJob::EXECENV] != "" then
              env = SenjuEnv.find_by(name: items[SenjuJob::EXECENV])
              raise "実行環境(#{items[SenjuJob::EXECENV]})が存在しません" unless env
              e.senjuEnv = env
          end
          e.save
      end
  end

  def import_triger
      SenjuTriger.delete_all

      import_object "#{WORK_DIR}/トリガ.txt" do |items|
          e = SenjuTriger.new(name: items[SenjuTriger::NAME],
                              description: items[SenjuTriger::DESC],
                              node: items[SenjuTriger::NODE],
                              path: items[SenjuTriger::PATH])
      end
  end

  def import_net
      SenjuNet.delete_all

      netBuf = []

      import_object "#{WORK_DIR}/ネット.定義有効日.txt" do |items|
          if items[SenjuNet::NAME] != "" then
              if netBuf.size > 0 and items[SenjuNet::NAME] != netBuf[0][SenjuNet::NAME] then
                  setupNet(netBuf.shift, netBuf)
              end
              netBuf.clear
          end
          netBuf << items
      end

      setupNet(netBuf.shift, netBuf)
  end

  def setupNet(net, children)
      name = net[SenjuNet::NAME]
      ent = SenjuNet.find_by(name: name)
      if not ent
          ent = SenjuNet.new
      end

      ent.description = net[SenjuNet::DESC]
      envname = net[SenjuNet::EXECENV]
      if envname != "" then
          env = SenjuEnv.find_by(name: envname)
          raise "実行環境(#{envname})が存在しません" unless env
          ent.senjuEnv = env
      end
      
      children.each do |item|
          appendChild(ent, item)
      end
      
      children.each do |item|
          setupAssociation ent, item
      end

      ent.save()
  end

  def addAssociation(net, child, pre_type, pre_name)
      pre_children = net.netReferences.select { |r| r.senjuObject.name == pre_name and r.senjuObject.class.SENJU_TYPE == pre_type }
      raise "Failed to find object by (#{child_name}:#{child_type})" if pre_children.empty?
      pre_child = pre_children.first
      succession = SenjuSuccession.new left: pre_child, right: child
  end

  def setupAssociation(net, items)
      child_type = items[SenjuNet::TYPE]
      child_name = items[SenjuNet::REF_NAME]

      children = net.netReferences.select { |r| r.senjuObject.name == child_name and r.senjuObject.class.SENJU_TYPE == child_type }

      raise "Failed to find object by (#{child_name}:#{child_type})" if children.empty?
      child = children.first

      for i in 0 .. SenjuNet::PRECEDE_COUNT - 1
          pre_type = items[SenjuNet::PRECEDE_START + i * 2]
          pre_name = items[SenjuNet::PRECEDE_START + i * 2 + 1]
          addAssociation(net, child, pre_type, pre_name)
      end
  end

  def find_or_create_net(name)
      ent = SenjuNet.find_by name: name
      if not ent then
          ent = SenjuNet.new name: name
      end
      return ent
  end

  def appendChild(net, items)
      child_type = items[SenjuNet::TYPE]
      child_name = items[SenjuNet::REF_NAME]
      child_env = items[SenjuNet::EXECENV]
      child_ent = nil

      child_ref = NetReferences.new senjuNet: net

      case child_type
      when SenjuNet::SENJU_TYPE then
          child_ref.senjuObject = find_or_create_net(child_name)
      when SenjuJob::SENJU_TYPE then
          child_ref.senjuObject = SenjuJob.find_by name: child_name
          raise "Failed to find job by #{child_name}" unless child_ref.senjuObject
      when SenjuTriger::SENJU_TYPE then
          child_ref.senjuObject = SenjuTriger.find_by name: child_name
          raise "Failed to find triger by #{child_name}" unless child_ref.senjuObject
      end

      if child_env != "" then
          child_ref.senjuEnv = SenjuEnv.find_by name: child_env
          raise "Failed to find environment by #{child_env}" unless child_ref.senjuEnv
      end
  end

end
