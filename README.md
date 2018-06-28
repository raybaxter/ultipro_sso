# ultipro_sso
Example Ruby code for interacting with [Ultipro Federated Single Sign-On (SSO) User Service](https://connect.ultipro.com/documentation#/api/1183) for creating SSO User Records. Note that the XML Example code on that page is not correct. It is for the Employee New Hire Service. The correct XML is in `create_user.xml` for your reference.

##To use

* Modify the top section of the files with your configuration parameters. Consult the [Ultipro API Documentation](https://connect.ultipro.com/documentation#/api)

* Add your users as DATA. Code expects EmployeeNumber and a single user name for both ClientUserName and UltiProUserName. If your implementation has different ClientUserName and UltiProUserName you will need to modify the code.

* Run from the command line. Records that were created print `true`, failures print `false`

```
        ultipro-sso $ ruby create_all.rb
        false    1234    bob@example.com
        true    2345    alice@example.com
        true    3456    jane@example.com

```

##To Do

* Improve error handling. This was a one-off, worked for me situation.
* Read from a file
* Pass configuration from command line
* This code requests a new token for each insert. Could cache that, but caching is a [hard problem](https://martinfowler.com/bliki/TwoHardThings.html).
* You can pass other identifiers