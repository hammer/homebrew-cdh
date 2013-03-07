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

### HDFS

#### Install CDH Hadoop

```bash
brew install cdh-hadoop
```

#### Edit configuration files

The `cdh-hadoop` formula uses `inreplace` to make the following changes, so you don't need to do them manually. These changes suppress some annoying warning messages and configure your cluster to run in pseudo-distributed mode.
* `etc/hadoop/hadoop-env.sh`: Append `java.security.krb5.realm` and `java.security.krb5.kdc` to `HADOOP_OPTS`
* `etc/hadoop/yarn-env.sh`: Append `java.security.krb5.realm` and `java.security.krb5.kdc` to `YARN_OPTS`
* `etc/hadoop/core-site.xml`: Set `hadoop.tmp.dir` and `fs.default.name`
* `etc/hadoop/hdfs-site.xml`: Set `dfs.replication`
* `etc/hadoop/log4j.properties`: Set `log4j.logger.org.apache.hadoop.util.NativeCodeLoader` log level to "ERROR"

#### Enable SSH to localhost
```bash
systemsetup -f -setremotelogin on
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
for host_id in localhost 0.0.0.0; do
  ssh-keyscan $host_id >> ~/.ssh/known_hosts
done
```

#### Format, start, and test HDFS
```bash
hdfs namenode -format
`brew --cellar`/cdh-hadoop/4.2.0/libexec/sbin/start-dfs.sh
hdfs dfs -mkdir hey
hdfs dfs -ls
```

### YARN
```bash
export HADOOP_CONF_DIR=`brew --cellar`/cdh-hadoop/4.2.0/libexec/etc/hadoop
`brew --cellar`/cdh-hadoop/4.2.0/libexec/sbin/start-yarn.sh
hadoop jar `brew --cellar`/cdh-hadoop/4.2.0/libexec/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.0.0-cdh4.2.0.jar pi 10 100
```
