homebrew-cdh
============

[Homebrew](http://mxcl.github.com/homebrew/) formulae for [CDH](http://www.cloudera.com/content/cloudera/en/products/cdh.html)

## Formulae
* cdh-hadoop

## Usage

```bash
brew tap hammer/cdh
```

I think you'll also need [Command Line Tools for Xcode](http://developer.apple.com/downloads).

### CDH 4: HDFS 2 with MapReduce 1

#### Install CDH Hadoop

```bash
brew install cdh-hadoop
brew install cdh-mr1
```

#### No need to edit configuration files

The `cdh-hadoop` formula uses `inreplace` to make the following changes, so you don't need to do them manually. These changes suppress some annoying warning messages and configure your cluster to run in pseudo-distributed mode.
* `etc/hadoop/hadoop-env.sh`: Append `java.security.krb5.realm` and `java.security.krb5.kdc` to `HADOOP_OPTS`
* `etc/hadoop/core-site.xml`: Set `hadoop.tmp.dir` and `fs.default.name`
* `etc/hadoop/hdfs-site.xml`: Set `dfs.replication`
* `etc/hadoop/log4j.properties`: Set `log4j.logger.org.apache.hadoop.util.NativeCodeLoader` log level to "ERROR"

The `cdh-mr1` formula uses `inreplace` to make the following changes, so you don't need to do them manually. These changes suppress some annoying warning messages and configure your cluster to run in pseudo-distributed mode.
* `etc/hadoop/hadoop-env.sh`: Append `java.security.krb5.realm` and `java.security.krb5.kdc` to `HADOOP_OPTS`
* `etc/hadoop/core-site.xml`: Set `hadoop.tmp.dir` and `fs.default.name`
* `etc/hadoop/mapred-site.xml`: Set `mapred.job.tracker`
* `etc/hadoop/log4j.properties`: Set `log4j.logger.org.apache.hadoop.util.NativeCodeLoader` log level to "ERROR"

#### Enable SSH to localhost
```bash
systemsetup -f -setremotelogin on
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
for host_id in localhost 0.0.0.0; do
  ssh-keyscan $host_id >> ~/.ssh/known_hosts
done
```

#### Format and start HDFS, ensure all processes are running
```bash
`brew --cellar`/cdh-hadoop/4.2.1/bin/hdfs namenode -format
`brew --cellar`/cdh-hadoop/4.2.1/libexec/sbin/start-dfs.sh
jps
```

#### Add some directories on HDFS
```bash
`brew --cellar`/cdh-hadoop/4.2.1/bin/hadoop fs -mkdir /tmp
`brew --cellar`/cdh-hadoop/4.2.1/bin/hadoop fs -chmod -R 1777 /tmp
`brew --cellar`/cdh-hadoop/4.2.1/bin/hadoop fs -mkdir -p /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
`brew --cellar`/cdh-hadoop/4.2.1/bin/hadoop fs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
```

#### Set HADOOP_HOME, Start MapReduce, ensure all processes are running
```brew
export HADOOP_HOME=`brew --cellar`/cdh-mr1/4.2.1/libexec
`brew --cellar`/cdh-mr1/4.2.1/bin/start-mapred.sh
jps
```

#### Add more directories, and data, on HDFS
```brew
`brew --cellar`/cdh-hadoop/4.2.1/bin/hadoop fs -mkdir /user/hammer
`brew --cellar`/cdh-hadoop/4.2.1/bin/hadoop fs -chown hammer /user/hammer
`brew --cellar`/cdh-hadoop/4.2.1/bin/hadoop fs -mkdir input
`brew --cellar`/cdh-hadoop/4.2.1/bin/hadoop fs -put `brew --cellar`/cdh-mr1/4.2.1/libexec/conf/*.xml input
```

#### Run a MapReduce job
```brew
`brew --cellar`/cdh-mr1/4.2.1/bin/hadoop jar `brew --cellar`/cdh-mr1/4.2.1/libexec/hadoop-examples-2.0.0-mr1-cdh4.2.1.jar grep input output 'dfs[a-z.]+'
```

#### Read results of MapReduce job
```brew
`brew --cellar`/cdh-hadoop/4.2.1/bin/hadoop fs -cat output/part-00000 | head
```
