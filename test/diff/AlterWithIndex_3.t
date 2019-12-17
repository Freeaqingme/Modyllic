#!/usr/bin/env php
<?php
/**
 * Tests if a FULLTEXT index can be changed into a UNIQUE index
 *
 * @package Modyllic
 * Ref: test5.sql / test5-2.sql
 */

require_once dirname(__FILE__)."/../test_environment.php";

plan( 5 );

$parser = new Modyllic_Parser();

$schema1_sql = <<< EOSQL
create table t1 (col1 serial, col2 varchar(20));

ALTER TABLE t1
ADD fulltext INDEX idx_name (col1);
EOSQL;

$schema2_sql = <<< EOSQL
create table t1 (col1 serial, col2 varchar(20));

ALTER TABLE t1
ADD UNIQUE INDEX idx_name (col1, col2);
EOSQL;

$schema1 = $parser->parse($schema1_sql);
$schema2 = $parser->parse($schema2_sql);

$diff = new Modyllic_Diff($schema1,$schema2);

$changes = $diff->changeset();

is($changes->has_changes(), true, "Changing charset and collation changes schema" );
is(count($changes->schema->from->errors), 0, "Errors while parsing");

is(count($changes->update['tables']['t1']->to->indexes), 2, "Two indexes were found");
is($changes->update['tables']['t1']->to->indexes['idx_name']->fulltext, false,
    "Secondary index is no full text index"
);
is($changes->update['tables']['t1']->to->indexes['idx_name']->unique, true,
    "Secondary index is unique index"
);
