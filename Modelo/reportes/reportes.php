<?php

class ReporteDia {

private $db;

public function __construct() 
{
        
         $this->db = new Conexion();
       
}

public function ventasDia(){
 $sql = "SELECT sum(dv.DVE_N_CANTIDAD*dv.DVE_N_PRECIO),sum(dv.DVE_N_CANTIDAD*dv.VEN_N_PRECIOCOMPRA) from sm_ventas v INNER join sm_detalleventas dv on dv.VEN_C_CODIGO=v.VEN_C_CODIGO where date(v.VEN_F_FECHAVENTA)=date(ahora()) group by date(v.VEN_F_FECHAVENTA);";
         $rows=$this->db->query($sql);  
		$result=$rows->fetch_array();
	
		return $result;
	
}
public function comprasDia(){
 $sql = "select sum(dc.COM_N_PRECIOC*dc.COM_N_CANTIDAD) from sm_compra c
INNER join sm_detallecompras dc on dc.C_C_CODIGO=c.C_C_CODIGO where date(c.AUD_F_FECHAINSERCION)=date(ahora()) GROUP by date(c.AUD_F_FECHAINSERCION);";
         $rows=$this->db->query($sql);  
		$result=$rows->fetch_array();
	
		return $result;
	
}
}



