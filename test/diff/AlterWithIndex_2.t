#!/usr/bin/env php
<?php
/**
 * @package Modyllic
 * Ref: test2.sql / test2-2.sql
 */

require_once dirname(__FILE__)."/../test_environment.php";

plan( 2 );

$parser = new Modyllic_Parser();

$schema1_sql = <<< EOSQL
CREATE TABLE ad_action (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  action varchar(64) NOT NULL,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
)
ENGINE = INNODB;

--
-- Create index `idx_ad_action` on table `ad_action`
--
ALTER TABLE ad_action
ADD INDEX idx_ad_action (action);

EOSQL;

$schema2_sql = <<< EOSQL
CREATE TABLE ad_action (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  action varchar(63) NOT NULL,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
)
ENGINE = INNODB;

--
-- Create index `idx_ad_action` on table `ad_action`
--
ALTER TABLE ad_action
ADD INDEX idx_ad_action (action, created);
EOSQL;

$schema1 = $parser->parse($schema1_sql);
$schema2 = $parser->parse($schema2_sql);

$diff = new Modyllic_Diff($schema1,$schema2);

$changes = $diff->changeset();

is($changes->has_changes(), true, "Changing charset and collation changes schema" );
is(count($changes->schema->from->errors), 0, "Errors while parsing");
