homebrew-cdh
============

[Homebrew](http://mxcl.github.com/homebrew/) formulae for [CDH](http://www.cloudera.com/content/cloudera/en/products/cdh.html)

## Formulae
* cdh-hadoop

## Usage

```bash
brew tap hammer/cdh
```

### HDFS

(Cf. http://ragrawal.wordpress.com/2012/04/28/installing-hadoop-on-mac-osx-lion/)

#### Install CDH Hadoop

```bash
brew install cdh-hadoop
```

#### Edit configuration files

The `cdh-hadoop` formula uses `inreplace` to make the following changes, so you don't need to do them manually:
* `etc/hadoop/hadoop-env.sh`: Append `java.security.krb5.realm` and `java.security.krb5.kdc` to `HADOOP_OPTS`
* `etc/hadoop/core-site.xml`: Set `hadoop.tmp.dir` and `fs.default.name`
* `etc/hadoop/hdfs-site.xml`: Set `dfs.replication`
* `etc/hadoop/log4j.properties`: Set `log4j.logger.org.apache.hadoop.util.NativeCodeLoader` log level to "ERROR"

#### Enable SSH to localhost
```bash
systemsetup -f -setremotelogin on
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
```

#### Format, start, and test HDFS
```bash
hdfs namenode -format
`brew --cellar`/cdh-hadoop/4.2.0/libexec/sbin/start-dfs.sh
hdfs dfs -mkdir hey
hdfs dfs -ls
```
