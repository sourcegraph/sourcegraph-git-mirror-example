# WIP

# Sourcegraph with a git mirror

This project is an example of how to set up Sourcegraph with a git mirror between
it and your code host.

## Overview

This project uses [RalfJung/git-mirror](https://github.com/RalfJung/git-mirror)
as the mirroring system. It uses [gitolite](http://gitolite.com/gitolite/index.html)
as the mirror. [Docker compose](https://docs.docker.com/compose/) is used to run
Sourcegraph and Gitolite. Once it's up and running, you'll be able to add your
code host as an external service to Sourcegraph. We'll cover the configuration needed
to clone through the mirror rather than the code host.

## Setup

To start, run the project with the following command:

```shell
SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" SSH_KEY_NAME="$(whoami)" make run
```

### Gitolite setup

Once gitolite is running, we'll need to give Sourcegraph permission to access it.

First, we need to get a public ssh key for Sourcegraph. Start by accessing the Sourcegraph Server:

```shell
docker exec -it sourcegraph /bin/bash
```

Next, navigate to the root user's ssh directory and create a key.

```shell
cd ~/.ssh
ssh-keygen # ... follow prompts to create the key

# Close the connection
exit
```

Once the key is created, copy that to your local machine.

```shell
docker cp sourcegraph:/root/.ssh/id_rsa.pub /tmp/id_rsa.pub
```

Next, we'll clone the `gitolite-admin` repository. To do this, we first must
tell `git clone` what port gitolite is listening on. In your `~/.ssh/config`,
add the following entry:

```shell
Host localhost
  User git
  Port 2222
```

Now, clone the repository:

```shell
git clone git@localhost:gitolite-admin
cd gitolite-admin
```

Once inside the admin repository, all we need to do is add the public key we created to
the `keydir` and push this change back to the origin.

```shell
cp /tmp/id_rsa.pub ./keydir
git add .
git commit -m "add sourcegraph public key"
git push origin
```
