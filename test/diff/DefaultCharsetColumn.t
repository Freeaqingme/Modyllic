#!/usr/bin/env php
<?php
/**
 * Verify that if the default charset of a table changes,
 * the charset of the columns differs as well.
 *
 * @package Modyllic
 * Ref: test4.sql / test4-2.sql
 */

require_once dirname(__FILE__)."/../test_environment.php";

plan( 5 );

$parser = new Modyllic_Parser();

$schema1_sql = <<< EOSQL
create table t1 (
    field varchar(255)
)
CHARACTER SET utf8,
COLLATE utf8_general_ci;
EOSQL;

$schema2_sql = <<< EOSQL
create table t1 (
    field varchar(255)
)
CHARACTER SET utf8mb4,
COLLATE utf8_unicode_ci;
EOSQL;

$schema1 = $parser->parse($schema1_sql);
$schema2 = $parser->parse($schema2_sql);

$diff = new Modyllic_Diff($schema1,$schema2);

$changes = $diff->changeset();

is($changes->has_changes(), true, "Changing charset and collation changes schema" );

is ($changes->schema->to->tables['t1']->collate, 'utf8_unicode_ci', 'Changed table collation');
is ($changes->schema->to->tables['t1']->charset, 'utf8mb4', 'Changed table charset');

is($changes->update['tables']['t1']->update['columns']['field']->type->charset(),
    'utf8mb4', 'Changed charset of field after table charset changed'
);
is($changes->update['tables']['t1']->update['columns']['field']->type->collate(),
    'utf8_unicode_ci', 'Changed collation of field after table collation changed'
);
