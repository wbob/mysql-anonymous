#!/usr/bin/env python
# This assumes an id on each field.
import logging
import hashlib
import random


log = logging.getLogger('anonymize')
common_hash_secret = "%016x" % (random.getrandbits(128))


def get_truncates(config):
    database = config.get('database', {})
    truncates = database.get('truncate', [])
    sql = []
    for truncate in truncates:
        sql.append('TRUNCATE `%s`' % truncate)
    return sql


def get_deletes(config):
    database = config.get('database', {})
    tables = database.get('tables', [])
    sql = []
    for table, data in tables.iteritems():
        if 'delete' in data:
            fields = []
            for f, v in data['delete'].iteritems():
                fields.append('`%s` %s' % (f, v))
            statement = 'DELETE FROM `%s` WHERE ' % table + ' AND '.join(fields)
            sql.append(statement)
    return sql

def get_postscript(config):
    database = config.get('database', {})
    postscript = database.get('postscript', [])
    sql = []
    for plainsql in postscript:
        sql.append('%s' % plainsql)
    return sql

listify = lambda x: x if isinstance(x, list) else [x]

def get_updates(config):
    global common_hash_secret

    database = config.get('database', {})
    tables = database.get('tables', [])
    sql = []
    for table, data in tables.iteritems():
        updates = []
        for operation, details in data.iteritems():
            if operation == 'nullify':
                for field in listify(details):
                    updates.append("`%s` = NULL" % field)
            elif operation == 'empty_string':
                for field in listify(details):
                    updates.append("`%s` = ''" % field)
            elif operation == 'random_int':
                for field in listify(details):
                    updates.append("`%s` = ROUND(RAND()*1000000)" % field)
            elif operation == 'random_ip':
                for field in listify(details):
                    updates.append("`%s` = INET_NTOA(RAND()*1000000000)" % field)
            elif operation == 'id_email':
                for field in listify(details):
                    updates.append("`%s` = CONCAT('userid_', id, '@localhost')" % field)
            elif operation == 'id_username':
                for field in listify(details):
                    updates.append("`%s` = CONCAT('userid_', id)" % field)
            elif operation == 'hash_zipcode':
                for field in listify(details):
                    updates.append("`%s` = LPAD(FLOOR(1 + (RAND() * 99998)), 5, '1')" % field)
            elif operation == 'random_ustid':
                for field in listify(details):
                    updates.append("`%s` = CONCAT('DE', LPAD(FLOOR(1 + (RAND() * 999999998)), 9, '0'))" % field)
            elif operation == 'random_legal_isodate':
                for field in listify(details):
                    updates.append("`%s` = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL FLOOR(18*365 + RAND() * 81*365) DAY), GET_FORMAT(DATE,'ISO'))" % field)
            elif operation == 'hash_value':
                for field in listify(details):
                    updates.append("`%(field)s` = MD5(CONCAT(@common_hash_secret, `%(field)s`))"
                                   % dict(field=field))
            elif operation == 'hash_length':
                for field in listify(details):
                    updates.append("`%(field)s` = LEFT(MD5(CONCAT(@common_hash_secret, `%(field)s`)), LENGTH(`%(field)s`))"
                                   % dict(field=field))
            elif operation == 'hash_email':
                for field in listify(details):
                    updates.append("`%(field)s` = CONCAT(LEFT(MD5(CONCAT(@common_hash_secret, `%(field)s`)), 12), '@localhost')"
                                   % dict(field=field))
            elif operation == 'hash_emailuser':
                for field in listify(details):
                    updates.append("`%(field)s` = CONCAT(LEFT(MD5(CONCAT(@common_hash_secret, `%(field)s`)), 12), '@', SUBSTRING_INDEX(`%(field)s`, '@', -1))"
                                   % dict(field=field))
            elif operation == 'delete':
                continue
            else:
                log.warning('Unknown operation.')
        if updates:
            sql.append('UPDATE `%s` SET %s' % (table, ', '.join(updates)))
    return sql


def anonymize(config):
    database = config.get('database', {})

    if 'name' in database:
         print "USE `%s`;" % database['name']

    print "SET FOREIGN_KEY_CHECKS=0;"

    sql = []
    sql.extend(get_truncates(config))
    sql.extend(get_deletes(config))
    sql.extend(get_updates(config))
    sql.extend(get_postscript(config))
    for stmt in sql:
        print stmt + ';'

    print "SET FOREIGN_KEY_CHECKS=1;"
    print

if __name__ == '__main__':

    import yaml
    import sys

    if len(sys.argv) > 1:
        files = sys.argv[1:]
    else:
        files = [ 'anonymize.yml' ]

    for f in files:
        print "--"
        print "-- %s" %f
        print "--"
        print "SET @common_hash_secret=rand();"
        print "SET @shopware_schema_version = (SELECT MAX(version) FROM s_schema_version);"
        print ""
        cfg = yaml.load(open(f))
        if 'databases' not in cfg:
            anonymize(cfg)
        else:
            databases = cfg.get('databases')
            for name, sub_cfg in databases.items():
                print "USE `%s`;" % name
                anonymize({'database': sub_cfg})
