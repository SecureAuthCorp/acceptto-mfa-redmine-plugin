![Acceptto](/Acceptto.png "Acceptto")

# Acceptto Multi Factor Authentication for Redmine

Acceptto is a Multi-Factor Authentication service that allows the use of your mobile device for authorizing requested logins. A notification in the form of SMS or Push is sent to your registered device, giving you full control to authorize or decline the logins. This plugin enables Multi-Factor Authentication for Redmine. (http://www.redmine.org)


## Installation

1- Copy acceptto_mfa folder into /plugin folder of redmine.

2- Run bundle install:

    bundle install

3- Run plugin migrations:

    rake redmine:plugins:migrate

4- Go to Administration > Plugins > Acceptto Multi-Factor Authentication plugin and click on "Configure" to change the default values.

## Testing Functionality

You can test Multi Factor Authentication functionality in your redmine installation with these steps:

1- Login into your redmine account.

2- Go to 'My Account' page. (upper right in default theme)

3- In preferences section of page you can see a new setting named: 'Multi Factor Auth: Enable Now'

4- Click on 'Enable Now' to activate the functionality.

5- After enabling multi factor authentication you can sign out and try to sign in again. This time you need to accept authentication on your device via Acceptto application.
