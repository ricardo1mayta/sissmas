<?php

class DetalleOrdenVenta {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}
	public  function savedetalleordenventa($idor,$idpro,$can,$prec,$prev,$sed,$idus,$us)
	{
		 $sql = "call spt_save_detalleordenventa('$idor','$idpro','$can','$prec','$prev','$sed','$idus','$us');";
            $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;
	}
}
