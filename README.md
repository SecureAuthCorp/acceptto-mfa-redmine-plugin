![Acceptto](/Acceptto.png "Acceptto")

Acceptto Multi Factor Authentication for Redmine
===========================

1- Run Patch File on your redmine source code:

    git am --signoff < acceptto-mfa.patch

2- Copy mfa folder into /plugin folder of redmine.

3- run bundle install:

    bundle install

4- run plugin migration: 

    rake redmine:plugins:migrate

5- This variables should be present in Rails.configuration:

    config.redmine_host = 'Address of your redmine host'
    config.mfa_app_uid = 'Application unique id you've got from Acceptto.'
    config.mfa_app_secret = 'Application secret you've got from Acceptto.'

for example:

    p Rails.configuration.redmine_host 

should return:

    'Address of your redmine host'