require 'formula'

class CdhHadoop < Formula
  homepage 'http://www.cloudera.com'
  url 'http://archive.cloudera.com/cdh4/cdh/4/hadoop-2.0.0-cdh4.2.0.tar.gz'
  sha1 '8b88bd2a8f866ac3d10cfaf737758d25a8f8bf3c'
  version '4.2.0'

  depends_on 'protobuf'
  
  def shim_script target
    <<-EOS.undent
    #!/bin/bash
    exec "#{libexec}/bin/#{target}" "$@"
    EOS
  end

  def install
    libexec.install %w[bin etc lib libexec sbin share]
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end

    inreplace "#{libexec}/etc/hadoop/hadoop-env.sh",
      "export HADOOP_IDENT_STRING=$USER",
      "
export HADOOP_IDENT_STRING=$USER
export HADOOP_OPTS=\"$HADOOP_OPTS -Djava.security.krb5.realm=OX.AC.UK -Djava.security.krb5.kdc=kdc0.ox.ac.uk:kdc1.ox.ac.uk\"
"

    inreplace "#{libexec}/etc/hadoop/yarn-env.sh",
      "YARN_OPTS=\"$YARN_OPTS -Dyarn.policy.file=$YARN_POLICYFILE\"",
      "
YARN_OPTS=\"$YARN_OPTS -Dyarn.policy.file=$YARN_POLICYFILE\"
YARN_OPTS=\"$YARN_OPTS -Djava.security.krb5.realm=OX.AC.UK -Djava.security.krb5.kdc=kdc0.ox.ac.uk:kdc1.ox.ac.uk\"
"

    inreplace "#{libexec}/etc/hadoop/core-site.xml",
      "</configuration>",
      "
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/Users/${user.name}/hadoop-store</value>
  </property>
  <property>
    <name>fs.default.name</name>
    <value>hdfs://localhost:8020</value>
  </property>
</configuration>
"

    inreplace "#{libexec}/etc/hadoop/hdfs-site.xml",
      "</configuration>",
      "
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
</configuration>
"

    inreplace "#{libexec}/etc/hadoop/log4j.properties",
      "# Custom Logging levels",
      "# Custom Logging levels
log4j.logger.org.apache.hadoop.util.NativeCodeLoader=ERROR
"
  end
  
  def test
    system "hadoop", "version"
  end
end
