<?php
/**
 * Copyright © 2012 Online Buddies, Inc. - All Rights Reserved
 *
 * @package Modyllic
 * @author bturner@online-buddies.com
 */

class Modyllic_Type_Json extends Modyllic_Type_String {
    function __construct($type) {
        parent::__construct($type);
    }
    function copy_from(Modyllic_Type $old) {
        parent::copy_from($old);
        $this->length = $old->length();
    }
    function to_sql(Modyllic_Type $other=null) {
        return 'JSON';
    }
    function make_binary() {
        $new = new Modyllic_Type_Blob("JSON");
        $new->copy_from($this);
        return $new;
    }

    function charset_collation(Modyllic_Type $other=null) { return ""; }

}
