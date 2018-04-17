<?php

class Tipopagos {

private $db;

public function __construct() 
{
        
         $this->db = new Conexion();
       
}
	
   

  

    public function get_alltipopagos() 
	{
        $sql = "SELECT * FROM `sm_tipospagos` WHERE TPG_E_ESTADO>0 ";
       $rows=$this->db->query($sql);  
        return $rows;
    }
  
}