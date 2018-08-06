# Introduction:

## Purpose and scope:

> As for most Best Practice guides, this document also is created to be
> a guide for the team members to have a set of standards to be used
> when using Ansible. As flexible as it is, a set of standards are much
> needed for that all teams members can easily use and maintain Ansible
> in our project. This document will state a basic directory structure
> of Ansible and a basic Ansible installation and usage.
>
## What is Ansible:

> Ansible is a radically simple IT automation
> engine that automates cloud provisioning, configuration
> management, application deployment, intra-service orchestration, and
> many other IT needs.
>
> Designed for multi-tier deployments, Ansible models your IT
> infrastructure by describing how all of your systems inter-relate,
> rather than just managing one system at a time.
>
> It uses no agents and no additional custom security infrastructure, so
> it\'s easy to deploy - and most importantly, it uses a very simple
> language (YAML, in the form of Ansible Playbooks) that allow you to
> describe your automation jobs in a way that approaches plain English.

>While there are many popular configuration management systems available
>for Linux systems, such as Chef and Puppet, these are often more complex
>than many people want or need.  Ansible is a great alternative to these
>options because it has a much smaller overhead to get started.

>Ansible works by configuring client machines from a computer with
>Ansible components installed and configured. It communicates over normal
>SSH channels in order to retrieve information from remote machines,
>issue commands, and copy files. Because of this, an Ansible system does
>not require any additional software to be installed on the client
>computers. This is one way that Ansible simplifies the administration of
>servers. Any server that has an SSH port exposed can be brought under
>Ansible\'s configuration umbrella, regardless of what stage it is at in
>its life cycle.

>Ansible takes on a modular approach, making it easy to extend to use the
>functionalities of the main system to deal with specific scenarios.
>Modules can be written in any language and communicate in standard JSON.
>Configuration files are mainly written in the YAML data serialization
>format due to its expressive nature and its similarity to popular markup
>languages. Ansible can interact with clients through either command line
>tools or through its configuration scripts called Playbooks.

## Assumptions:

>    This document was created with a few assumptions.
>
>	1.  Centos 7
>
>	2.  Python 2.7.5
>
>	3.  ssh enabled

# Basic Setup and Configuration

## Installing Ansible

> To begin exploring Ansible as a means of managing our various servers,
> we need to install the Ansible software on at least one machine. 
>
> To get Ansible for CentOS 7, first ensure that the CentOS 7 EPEL
> repository is installed:
>
> \$sudo yum install epel-release
>
> Once the repository is installed, install Ansible with yum:
>
> \$sudo yum install ansible
>
> We now have all of the software required to administer our servers
> through Ansible.

## Configuring Ansible Hosts

> Ansible keeps track of all of the servers that it knows about through
> a \"hosts\" file. We need to set up this file first before we can
> begin to communicate with our other computers.
>
> Open the file with root privileges like this:
>
> \$sudo vi /etc/ansible/hosts
>
> You will see a file that has a lot of example configurations commented
> out. Keep these examples in the file to help you learn Ansible\'s
> configuration if you want to implement more complex scenarios in the
> future.
>
> The hosts file is fairly flexible and can be configured in a few
> different ways. The syntax we are going to use though looks something
> like this:

## Set up ssh connectivity to the servers

> For this example, I\'ll assume you have servers with the
> hostnames host1.dev and host2.dev. Your /etc/ansible/hosts file would
> look like this:
>
> host1.dev
>
> host2.dev
>
> You want to be able to connect to your servers without having to enter
> a password every time. If you don\'t already have ssh key
> authentication set up to your children nodes, then do the
> following\...
>
> Generate the ssh key on the master node:
>
> root@master:\~\# ssh-keygen -t rsa -C \"name@example.org\"
>
> Then copy your public key to the servers with ssh-copy-id:
>
> root@master:\~\# ssh-copy-id user@host1.dev
>
> root@master:\~\# ssh-copy-id user@host2.dev
>
> Now you can test the connectivity:
>
> root@master:\~\# ansible all -m ping
>
> host1.dev \| success \>\> {
>
> \"changed\": false,
>
> \"ping\": \"pong\"
>
> }
>
> host2.dev \| success \>\> {
>
> \"changed\": false,
>
> \"ping\": \"pong\".

## Version Control:

> It should be clear that Ansible uses text files and therefore
> well-established version control will save a lot of time and headache.
>
> We will use gitlab in our dicelab to manage our version control. (
> this section will be updated as I get my access to the dicelab and
> understand the environment )

## Setup and Connection to AWS

> There are number of modules for controlling AWS. To control AWS
> environment, ansible requires an additional python module, boto. Boto
> can be installed using yum.
>
> Example: yum install python-boto
>
> (Update to this section will be made once we have our environment in
> AWS.)

## Basic OS configuration

> For ease of the user from typing ansible-playbook every time to
> execute ansible, it is recommended that you add an alias for
> ansible-play in your shell.
>
> Bash shell example:
>
> cd \~
>
> vi .bash\_profile
>
> insert the line below:
>
> alias apl=ansible-playbook

## Ansible Configuration

> Recommend making the following settings for ansible.
>
> In any shell, vi /etc/ansible/ansible.cfg and uncomment the follow
> arguments and change the value.
>
> \[ssh\_connection\]
>
> \# Enable SSH multiplexing to increase performance
>
> pipelining = True
>
> retry\_files\_save\_path=\~/.retry\_files
>
> retry\_files\_enabled=false
>
> If you are annoyed by \*.retry files being created next to playbooks
> which hinders filename tab completion, an environment variable
> RETRY\_FILES\_SAVE\_PATH lets you put them in a different place or you
> can disable it from creating retry files by
> RETRY\_FILES\_ENABLED=false.

# Best Practices:

## Comments

> You should start every script with some comments explaining the
> purpose of the script. Comments will make the intent of the script
> clearer.
>
> "\#" is used to indicate a comment.
>

## Single Quotes

> Preference by a lot of ansible users are to use single quotes over
> double quotes. The only time you should use double quotes is when they
> are nested within single quotes (e.g. Jinja map reference), or when
> your string requires escaping characters (e.g. using \"\\n\" to
> represent a newline).
>

## End of Files

> You should end your ansible scripts with a newline to avoid any prompt
> misalignment when printing files in a terminal.

## Spacing

> When indenting, you should use 2 spaces to represent sub-maps.You
> should have blank lines between two host blocks, between two task
> blocks, and between host and included blocks. This will produce nicer
> looking and easier to read code and also python is very finicky with
> spacing.
>

## "Name" Your Plays and Tasks

> Just as providing a good comment to describe the purpose of the script
> is important, a good descriptive "name" can make a user of the
> playbook understand each step within the play. Good descriptive "name"
> better communicates the steps of actions when running a play. Consider
> this example play and its standard Ansible output.
>
> YAML
>
> \- hosts: web
>
> tasks:
>
> \- yum:
>
> name: httpd
>
> state: latest
>
> \- service:
>
> name: httpd
>
> state: started
>
> enabled: yes
>
> PLAY \[web\]
> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
>
> TASK \[setup\]
> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
>
> ok: \[web1\]
>
> TASK \[yum\]
> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
>
> ok: \[web1\]
>
> TASK \[service\]
> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
>
> ok: \[web1\]
>
> The play above was successful, but it is difficult to understand the
> actions of each tasks. You can guess what each of the tasks were or
> the purpose of the play, but a good descriptive "name" can make the
> task much clearer.
>
> YAML
>
> \- hosts: web
>
> name: installs and starts apache
>
> tasks:
>
> \- name: install apache packages
>
> yum:
>
> name: httpd
>
> state: latest
>
> \- name: starts apache service
>
> service:
>
> name: httpd
>
> state: started
>
> enabled: yes
>
> PLAY \[install and starts apache\]
> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
>
> TASK \[setup\]
> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
>
> ok: \[web1\]
>
> TASK \[install apache packages\]
> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
>
> ok: \[web1\]
>
> TASK \[starts apache service\]
> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
>
> ok: \[web1\]
>
> A good "name" can reduce the confusion and aid the usage of
> the \--list-tasks switch in ansible-playbook.
>

## Meaningful Variable names

> To help to clarify, variable names should be meaningful. But ansible
> variable names have some restrictions in Ansible:
>
> Variable names should be letters, numbers, and underscores. Variables
> should always start with a letter. It is recommended prefixing
> variables with source or target of the data it reparents and to use
> snake\_case for variable names.
>
> Example:
>
> apache\_max\_keepalive: 25
>
> apache\_port: 80
>
> tomcat\_port: 8080
>
 
## Use modules before run commands

> Run commands are what we collectively call
> the command, shell, raw and script modules that enable users to do
> command line operations in different ways. They're a great catch all
> mechanism for getting things done, but they should be used sparingly
> and as a last resort. Firing off a bash command you already know
> without stopping to look at the Ansible docs works well enough
> initially, but it undermines the value of automating with Ansible and
> sets things up for problems down the road.The most important thing to
> consider is that these run commands have little logic to them and no
> concept of desired state like a typical Ansible module.
>

### Use roles to group related tasks

> In Ansible, roles allow you to group related tasks and all their
> variables and dependencies into a single, self-contained, portable
> entity. Grouping your tasks into roles is one of the best ways to
> maximize the power of Ansible's modularity and reusability, as
> organizing things into roles let you reuse common configuration steps
> between different types of servers.
>
####   Requirements for using role?

> Roles provide a standardized file-and-directory structure that lets
> Ansible automatically load variables, tasks, handlers, and default
> values into your Ansible Playbooks.
>
> Per the Ansible roles documentation, a role must contain:

#####      1.  at least one of the following directories below.

#####      2.  each directory used must contain a main.yml file that contains the
    relevant content for that directory.

    -   **Tasks:** The main list of tasks to be executed by the role.

    -   **Templates:** Templates of files whose final state will be
        rendered on the server using variable substitution and
        additional logic.

    -   **Files:** Static files that will be deployed to the server
        as-is.

    -   **Vars:** Variables that will be used to fill in abstractions in
        tasks and templates.

    -   **Defaults:** Default values for all variables used in the role.

    -   **Handlers:** Actions that are triggered/notified by tasks.
        Typically used for restarting services.

    -   **Meta:** Machine-readable metadata about the role, its author,
        license, compatibilities, and dependencies. If a role depends on
        another role, it's declared here, and Ansible will pull in the
        dependent role automatically.

    -   **README:** Human-readable information about the role, how to
        use it, and what variables it requires.

> Using roles to run will simplify your playbooks. In this example
> below, the tasks needed to configure the webserver, database, and
> common nodes are each defined in separate, portable, reusable roles
> instead of being defined in the playbook itself.
>
> You could go from this using playbook:
>
> \# site.yml
>
> \-\--
>
> \- hosts: all
>
> vars:
>
> remote\_user: user
>
> become: yes
>
> tasks:
>
> \- name: Install ntp
>
> yum: name=ntp state=present
>
> tags: ntp
>
> \- name: Configure ntp file
>
> template: src=ntp.conf.j2 dest=/etc/ntp.conf
>
> tags: ntp
>
> notify: restart ntp
>
> \- name: Start the ntp service
>
> service: name=ntpd state=started enabled=yes
>
> tags: ntp
>
> \- name: test to see if selinux is running
>
> command: getenforce
>
> register: sestatus
>
> changed\_when: false
>
> \- hosts: database
>
> vars:
>
> mysql\_port: 3306
>
> dbname: somedb
>
> dbuser: someuser
>
> dbpass: somepass
>
> remote\_user: user
>
> become: yes
>
> tasks:
>
> \- name: Install Mysql package
>
> yum: name={{ item }} state=installed
>
> with\_items:
>
> \- mysql-server
>
> \- MySQL-python
>
> \- libselinux-python
>
> \- libsemanage-python
>
> \- name: Configure SELinux to start mysql on any port
>
> seboolean: name=mysql\_connect\_any state=true persistent=yes
>
> when: sestatus.rc != 0
>
> \- name: Create Mysql configuration file
>
> template: src=my.cnf.j2 dest=/etc/my.cnf
>
> notify:
>
> \- restart mysql
>
> \- name: Start Mysql Service
>
> service: name=mysqld state=started enabled=yes
>
> \- name: insert iptables rule
>
> lineinfile: dest=/etc/sysconfig/iptables state=present regexp=\"{{
> mysql\_port }}\" insertafter=\"\^:OUTPUT \" line=\"-A INPUT -p tcp
> \--dport {{ mysql\_port }} -j ACCEPT\"
>
> notify: restart iptables
>
> \- name: Create Application Database
>
> mysql\_db: name={{ dbname }} state=present
>
> \- name: Create Application DB User
>
> mysql\_user: name={{ dbuser }} password={{ dbpass }} priv=\*.\*:ALL
> host=\'%\' state=present
>
> Using roles:
>
> \# site.yml
>
> \-\--
>
> \# This playbook deploys the whole application stack in this site.
>
> \- name: apply common configuration to all nodes
>
> hosts: all
>
> remote\_user: user
>
> roles:
>
> \- common
>
> \- name: configure and deploy the webservers and application code
>
> hosts: webservers
>
> remote\_user: user
>
> roles:
>
> \- web
>
> \- name: deploy MySQL and configure the databases
>
> hosts: dbservers
>
> remote\_user: user
>
> roles:
>
> -db

Directory Layout
----------------

> Below is the top level of the directory would contain files and
> directories like so:
>
> production \# inventory file for production servers
>
> staging \# inventory file for staging environment
>
> group\_vars/ \# here we assign variables to particular groups
>
> host\_vars/ \# here we assign variables to particular systems
>
> library/ \# if any custom modules, put them here (optional)
>
> module\_utils/ \# if any custom module\_utils to support modules, put
> them here (optional)
>
> filter\_plugins/ \# if any custom filter plugins, put them here
> (optional)
>
> roles/
>
> common/ \# this hierarchy represents a \"role\"
>
> tasks/
>
> main.yml \# tasks file can include smaller files if warranted
>
> handlers/
>
> main.yml \# handlers file
>
> templates/ \# files for use with the template resource
>
> ntp.conf.j2 \# templates end in .j2
>
> files/
>
> bar.txt \# files for use with the copy resource
>
> foo.sh \# script files for use with the script resource
>
> vars/
>
> main.yml \# variables associated with this role
>
> defaults/
>
> main.yml \# default lower priority variables for this role
>
> meta/
>
> main.yml \# role dependencies
>
> library/ \# roles can also include custom modules
>
> module\_utils/ \# roles can also include custom module\_utils
>
> lookup\_plugins/ \# or other types of plugins, like lookup in this
> case
>
> webtier/ \# same kind of structure as \"common\" was above, done for
> the webtier role
>
> monitoring/
>
> Script below will create the directory structure above.
>
> \#!/bin/sh
>
> touch production staging
>
> mkdir group\_vars
>
> touch group\_vars/group1
>
> touch group\_vars/group2
>
> mkdir host\_vars
>
> touch host\_vars/hostname1
>
> touch host\_vars/hostname2
>
> mkdir library
>
> touch library/.keep
>
> mkdir filter\_plugins
>
> touch filter\_plugins/.keep
>
> touch site.yml
>
> touch webservers.yml
>
> touch dbservers.yml
>
> mkdir -p roles/{common,webtier,monitoring,fooapps}
>
> mkdir -p
> roles/common/{tasks,handlers,templates,files,vars,defaults,meta}
>
> touch roles/common/tasks/main.yml
>
> touch roles/common/handlers/main.yml
>
> touch roles/common/templates/ntp.conf.j2
>
> touch roles/common/files/bar.txt
>
> touch roles/common/files/foo.sh
>
> touch roles/common/vars/main.yml
>
> touch roles/common/defaults/main.yml
>
> touch roles/common/meta/main.yml
>
> touch roles/webtier/.keep
>
> touch roles/monitoring/.keep
>
> touch roles/monitoring/.keep
>
> touch roles/fooapps/.keep
