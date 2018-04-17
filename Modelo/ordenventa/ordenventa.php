<?php

class OrdenVenta {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}
	public  function save_ordenventa($idus,$uscrea,$idsed)
	{
		echo  $sql = "call spt_save_ordenventa('$idus','$uscrea','$idsed');";
            $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;
	}
	public  function usuariossede($idsed,$txt)
	{
		 $sql = "select * from dg_user u INNER  join dg_sedes s on s.SED_C_CODIGO=u.SED_C_CODIGO where s.SED_C_PADRE=1 and u.US_D_NOMBRE LIKE'$txt%' LIMIT 10;";
         $rows=$this->db->query($sql);  
         
         return $rows;
	}
}
