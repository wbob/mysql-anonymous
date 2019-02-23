## Mysql Anonymous

Contributors can benefit from having real data when they are developing.
This script can do a few things (see `anonymize.yml`):

* Truncate any tables (logs, and other cruft which may have sensitive data)
* Nullify fields (emails, passwords, etc)
* Empty string
* Fill in random/arbitrary data:
    * Random integers
    * Random IP addresses
    * Email addresses
    * Usernames
    * taxid
* Delete rows based on rules:  e.g.
   `DELETE FROM mytable WHERE email NOT LIKE "%@localhost"`:

```yaml
    database:
        tables:
            mytable:
                delete:
                    email: 'NOT LIKE "%@localhost"'

```
### Usage

Edit the database name in the yaml, it will be included in `USE <db>;`

```bash
python anonymize.py shopware.yml > shopware.sql
cat shopware.sql | mysql
```
