<?php
/**
 * Copyright © 2012 Online Buddies, Inc. - All Rights Reserved
 *
 * @package Modyllic
 * @author bturner@online-buddies.com
 */

abstract class Modyllic_Schema_CodeBody extends Modyllic_Diffable {
    public $body = "BEGIN\nEND";
    public $begin_label = null;
    /**
     * @returns string Strips any comments from the body of the routine--
     * this allows the body to be compared to the one in the database,
     * which never has comments.
     */
    function _body_no_comments() {
        $stripped = $this->body;
        # Strip C style comments
        $stripped = preg_replace('{/[*].*?[*]/}su', '', $stripped);
        # Strip shell and SQL style comments
        $stripped = preg_replace('/(#|--).*/u', '', $stripped);
        # Strip leading and trailing whitespace
        $stripped = preg_replace('/^\h+|\h+$/mu', '', $stripped);
        # Collapse repeated newlines
        $stripped = preg_replace('/\n+/u', "\n", $stripped);
        return $stripped;
    }

    function equal_to(Modyllic_Schema_CodeBody $other) {
        if ( get_class($other) != get_class($this) ) { return false; }
        if ( $this->begin_label != $other->begin_label ) { return false; }
        if ( $this->_body_no_comments() != $other->_body_no_comments() ) { return false; }
        return true;
    }

}
