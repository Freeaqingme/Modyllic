#!/usr/bin/env php
<?php
/**
 * This test tests the goto/label that's inside Modyllic_Parser::partial()
 * Without that goto, this test will fail:
 *
 *    "Can't alter t2 as t2 does not exist"
 *
 * @package Modyllic
 */

require_once dirname(__FILE__)."/../test_environment.php";

plan( 1 );

$parser = new Modyllic_Parser();

$sql = <<< EOSQL
create table t1(id serial, foobar int(20));

ALTER TABLE t1
ADD CONSTRAINT `fk-t1-id` FOREIGN KEY (foobar)
REFERENCES t1 (id);

CREATE TABLE t2 (
id serial,
PRIMARY KEY (id)
) ENGINE = INNODB;

ALTER TABLE t2
ADD INDEX idx_barfoo (id);
EOSQL;

$schema = $parser->parse($sql);
is(count($schema->tables), 2, 'Two tables were found');
