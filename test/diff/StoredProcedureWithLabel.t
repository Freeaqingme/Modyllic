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
DELIMITER $$

CREATE DEFINER = 'root'@'localhost'
PROCEDURE dothings ()
old_label:
  BEGIN
    DECLARE foo int DEFAULT 0;
  END

$$

EOSQL;

$schema2_sql = <<< EOSQL
DELIMITER $$

CREATE DEFINER = 'root'@'localhost'
PROCEDURE dothings ()
new_label:
  BEGIN
    DECLARE foo int DEFAULT 0;
  END

$$
EOSQL;

$schema1 = $parser->parse($schema1_sql);
$schema2 = $parser->parse($schema2_sql);

$diff = new Modyllic_Diff($schema1,$schema2);

$changes = $diff->changeset();

is($changes->has_changes(), true, "We have changes" );
is(count($changes->schema->from->errors), 0, "Errors while parsing");

is($changes->update['routines']['dothings']->begin_label, 'new_label', 'begin label changed');
