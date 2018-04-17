<?php

//include_once '../config.ini.php';

class Sedes{

private $db;

public function __construct() 
{
        $this->db = new Conexion();
        
}
	
    
   
    public function get_allSedes() {
        $sedes=$this->db->query("SELECT * FROM dg_sedes ");
       
        return $sedes;

    }
    public function get_allSedespadre($us) {
        $sedes=$this->db->query("SELECT * FROM dg_sedes where SED_C_PADRE=sedepadre('$us');");
       
        return $sedes;

    }
    public function user_sub_menu($uid,$idpad) {
        $menu=$this->db->query("SELECT DISTINCT * FROM dg_vista_menu WHERE US_C_CODIGO=".$uid." AND VIS_P_PADRE=".$idpad);
        
        return $menu;

       /* $menudata= mysql_fetch_array($menu);
        $_SESSION['menu'] = $menudata;*/
    }

}

?>
