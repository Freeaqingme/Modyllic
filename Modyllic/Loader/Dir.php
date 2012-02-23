<?php
/**
 * Copyright © 2012 Online Buddies, Inc. - All Rights Reserved
 *
 * @package Modyllic
 * @author bturner@online-buddies.com
 */

class Modyllic_Loader_Dir {
    static function load( $dir, $schema ) {
        $filelist = glob("$dir/*.sql",GLOB_NOSORT);
        natsort($filelist);
        Modyllic_Loader::load( $filelist, $schema );
    }
}