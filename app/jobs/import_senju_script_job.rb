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
      f = File.new(path)
      File::readable?(f) or raise "Failed to open #{path}"

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
          if items[SenjuJob::EXECENV] <> "" then
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
          if items[SenjuNet::NAME] <> "" then
              if netBuf.size > 0 and items[SenjuNet::NAME] <> netBuf[0][SenjuNet::NAME] then
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
      if envname <> "" then
          env = SenjuEnv.find_by(name: envname)
          raise "実行環境(#{envname})が存在しません" unless env
          ent.senjuEnv = env
      end
      
      children.each do |item|
          appendChild(ent, item)
      end

      ent.save()
  end

end
