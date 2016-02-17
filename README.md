## Developer setup instructions

### Software Install (OS X specific)

1. Install Homebrew:
`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)”`
1. Install Homebrew Cask: `brew install caskroom/cask/brew-cask`
1. Install Virtualbox: `brew cask install virtualbox`
1. Install Vagrant: `brew cask install vagrant`
1. Install git: `brew install git`

### Development Process

1. `vagrant up` to start the local virtual machine and to automatically provision a production-like dev environment using the script `provision.sh`
1. make changes to files locally inside `./website` (and preview the changes at http://localhost:8080/)
1. `vagrant push` to send the changes to remote test server (e.g. AWS) via SFTP
1. view the changes on the remote test server
1. `vagrant ssh` to login to the local dev VM to inspect it - although this shouldn't normally be required (make your environment changes to `provision.sh` instead)
###### repeat Steps 2-4 as necessary and commit to git once your changes have been tested and look OK

When finished for the day you can either `vagrant halt` to put your dev environment to sleep or `vagrant destroy` to remove it and recover disk space.

#### Example Project Setup

The example project is a CentOS 7 environment which installs mysql, apache, git and PHP

`git clone https://github.com/cwkendall/vagrant-sample.git`

To test this workflow with your site, checkout your project code into the folder `./website` as this is accessible inside the virtual machine under the apache webroot. This means that the  virtual machine will automatically serve your latest changes for local testing/previews. How does this work?
* By default, vagrant maps the local directory on the host as a virtualbox shared folder inside the guest as /vagrant.
* In the `provision.sh` script /vagrant is symlinked to /var/www/html via:

    `ln -s /vagrant/website /var/www/html/`

* Finally this website folder is synced with the remote server when `vagrant push` is run. More on this in the next section.

#### Remote Push Configuration

`vagrant push` enables the local files to be synced to a remote server.

The `Vagrantfile` has a section which defines the location of the remote server and the credentials. You will need to configure the remote server (I've used an example on AWS here) to allow the SSH/SFTP login e.g. via public key authentication or password.

    config.push.define "ftp" do |push|
      push.host = "54.79.29.231"
      push.secure = true
      push.username = "centos"
      push.dir = "website"
      push.destination = "/var/www/html/"
    end

Edit `provision.sh` to match your target environment e.g. install third-party packages, setup a database etc...

#### Getting help
To show your changes to others (they don't even need Vagrant installed) you can run `vagrant share`. It will provide a HTTP link into your vagrant environment that anyone can use.

SSH and general (non-HTTP) sharing can be arranged if the other user has vagrant installed using `vagrant connect`

For more details see:
https://www.vagrantup.com/docs/share/

### Migrating to AWS - Advanced Usage

With a special plugin installed and some further configuration it is possible to have vagrant drive an AWS environment directly i.e. `vagrant up --provider=aws` creates one or more virtual machines within AWS. Each remote VM can be automatically provisioned via scripts and the local folder contents can rsync'ed (one-way only).

`vagrant rsync` is used instead in this case rather than `vagrant push`

`vagrant rsync-auto` will start watching for local file changes and automatically rsync on save

See Vagrant AWS plugin:
https://github.com/mitchellh/vagrant-aws

Vagrant Rsync support:
https://www.vagrantup.com/docs/synced-folders/rsync.html
