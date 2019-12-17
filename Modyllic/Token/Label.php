<?php
/**
 * Copyright © 2013 Online Buddies, Inc. - All Rights Reserved
 *
 * @package Modyllic
 * @author bturner@online-buddies.com
 */

/**
 * Label type tokens
 */
class Modyllic_Token_Label extends Modyllic_Token implements Modyllic_Token_Ident {
    function token() {
        return $this->value();
    }

    function is_reserved() {
        return Modyllic_SQL::is_reserved($this->token());
    }
    function is_ident() {
        return ! $this->is_reserved();
    }
}
