<?php

class Devoluciones {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}
	public function get_cliente(){
			 $sql = "SELECT VEN_C_NOMBRECLIENTE,date(VEN_F_FECHAVENTA),nombresede(SED_C_CODIGO) FROM sm_ventas WHERE VEN_V_NUMERO=1";
	       	 $rows=$this->db->query($sql);
	         $result=$rows->fetch_array();
	         return $result;

	}
	public function get_productos(){
			 $sql = "SELECT DVE_D_NOMBREPRODUCTO,DVE_N_CANTIDAD,DVE_C_CODIGO FROM sm_detalleventas WHERE VEN_C_CODIGO=1";
	       	 $rows=$this->db->query($sql);	         
	         return $rows;
	}
}