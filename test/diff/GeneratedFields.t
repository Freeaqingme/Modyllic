#!/usr/bin/env php
<?php
/**
 * @package Modyllic
 * Ref: test3.sql / test3-2.sql
 */

require_once dirname(__FILE__)."/../test_environment.php";

plan( 4 );

$parser = new Modyllic_Parser();

$schema1_sql = <<< EOSQL
CREATE TABLE t1 (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  signup_data text DEFAULT NULL,
  col3 varchar(20) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(`signup_data`, '$.field1'))) STORED,
  col4 varchar(10) GENERATED ALWAYS AS (JSON_QUOTE(JSON_UNQUOTE(JSON_EXTRACT(`signup_data`, '$.field2')))) STORED,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 1337,
AVG_ROW_LENGTH = 123123123,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_general_ci;
EOSQL;

$schema2_sql = <<< EOSQL
CREATE TABLE t1 (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  signup_data text DEFAULT NULL,
  col3 varchar(20) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(`signup_data`, '$.field10'))) STORED,
  col4 varchar(10) GENERATED ALWAYS AS (JSON_QUOTE(JSON_UNQUOTE(JSON_EXTRACT(`signup_data`, '$.field2')))),
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 1337,
AVG_ROW_LENGTH = 123123123,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_general_ci;
EOSQL;

$schema1 = $parser->parse($schema1_sql);
$schema2 = $parser->parse($schema2_sql);

$diff = new Modyllic_Diff($schema1,$schema2);

$changes = $diff->changeset();

is($changes->has_changes(), true, "Changing generated columns" );
is(count($changes->schema->from->errors), 0, "Errors while parsing");
is($changes->update['tables']['t1']->update['columns']['col3']->virtual_def,
    '(JSON_UNQUOTE(JSON_EXTRACT(signup_data,\'$.field10\')))',
    'Changed definition'
);
is($changes->update['tables']['t1']->update['columns']['col4']->virtual_stored, false,
    'Changed STORED -> not STORED'
);
