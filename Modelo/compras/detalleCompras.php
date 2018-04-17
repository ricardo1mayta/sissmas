<?php

class Detallecompras {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}

	function save_detallecompra($idpv ,$us,$idsed,$tipodoc,$num,$tipomoneda,$tipocambio){

		 $sql = "call spt_save_detallecompra('$idpv','$us','$idsed','$tipodoc','$num','$tipomoneda','$tipocambio');";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;
	}
	function get_detallecompras($idcom){

		 $sql = "select COM_C_CODIGO,PRO_D_NOMBRE,COM_N_PRECIOC,COM_N_CANTIDAD,(COM_N_PRECIOC*COM_N_CANTIDAD) AS S_TOTAL,(CASE dc.COM_N_MONEDA WHEN 'Dolares' then '$. ' else 'S/. ' END) AS MONEDA from  sm_detallecompras dc 
inner join sm_productos p on p.PRO_C_CODIGO=dc.PRO_C_CODIGO WHERE COM_E_ESTADO>0 and C_C_CODIGO='$idcom'";
          $rows=$this->db->query($sql);  
             return $rows;
	}


}

?>