<?php

class Creditos {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}
	//funcion 	que guarda los pedidos
	public function abonar($idcre,$monto,$us,$obs,$img,$tipopago) 
    {
       $sql = "call spt_save_pagov('$idcre','$monto','$us','$obs','$img','$tipopago')";
        
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
    public function abonarcompras($idcre,$monto,$us,$obs,$img,$tipopago,$tipomoneda,$tipocambio) 
    {
       $sql = "call spt_save_pagoc('$idcre','$monto','$us','$obs','$img','$tipopago','$tipomoneda','$tipocambio')";
        
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
    public function get_creditos($idsed) 
    {
        $sql = "select cv.CV_C_CODIGO,c.SED_C_CODIGO,cv.CLI_C_CODIGO,concat(CLI_D_NOMBRE,' ',CLI_D_APELLIDOS) AS CLI_D_NOMBRE,cv.CV_N_TOTAL,ifnull((select sum(VV_N_ABONA) from sm_pagosv where CV_C_CODIGO=cv.CV_C_CODIGO ),0) AS CV_N_CANCELA,cv.CV_F_FECHACREA,cv.CV_F_FECHAVENCE 
from sm_cuentasventas cv
inner join sm_cliente c on c.CLI_C_CODIGO=cv.CLI_C_CODIGO
where c.SED_C_CODIGO='$idsed' AND CV_E_ESTADO=1;";
         $rows=$this->db->query($sql);  
         
         return $rows;

    }
    public function get_creditoscompras($idsed) 
    {
        $sql = "SELECT cc.CC_C_CODIGO,p.SED_C_CODIGO,p.PV_C_CODIGO,p.PV_D_NOMBRES,cc.CC_N_TOTAL,IFNULL((select sum(PC_N_ABONA) from sm_pagosc where CC_C_CODIGO=cc.CC_C_CODIGO),0) AS CC_N_CANCELA,cc.AUD_F_FECHACREA as PV_F_FECHACREA,(CASE cc.CC_N_MONEDA WHEN 'Dolares' then '$. ' else 'S/. ' END) AS MONEDA,cc.CC_N_MONEDA,cc.CC_F_FECHAVENCE  FROM sm_cuentascompras cc INNER JOIN sm_provedores p on p.PV_C_CODIGO=cc.PV_C_CODIGO
where p.SED_C_CODIGO='$idsed' AND cc.CC_E_ESTADO=1;";
         $rows=$this->db->query($sql);  
         
         return $rows;

    }
     public function get_ventascredito($idcre) 
    {
        $sql = "SELECT CONCAT(VEN_V_TIPO,right(CONCAT('00000000',VEN_V_NUMERO),8)) COD_DOC,VEN_C_NOMBRECLIENTE,dv.VEN_C_CODIGO,VEN_N_TOTAL,VEN_F_FECHAVENTA FROM sm_detallecuentasventas dv
inner JOIN sm_ventas v  ON v.VEN_C_CODIGO=dv.VEN_C_CODIGO where CV_C_CODIGO='$idcre';";
         $rows=$this->db->query($sql);  
         
         return $rows;

    }
     public function get_comprascredito($idcre) 
    {
        $sql = "SELECT dc.C_C_CODIGO,(case c.T_C_CODIGO when 1 then 'F' WHEN 2 then 'B' ELSE 'P' end ) as NUMCOMPRA,c.C_N_NUMDOC,(co.COM_N_PRECIOC*co.COM_N_CANTIDAD) as TOTAL,c.AUD_F_FECHAINSERCION FROM sm_detallecuentascompras dc inner join sm_compra c 
INNER JOIN sm_detallecompras co on co.C_C_CODIGO=c.C_C_CODIGO
where dc.CC_C_CODIGO='$idcre'
GROUP BY dc.C_C_CODIGO ";
         $rows=$this->db->query($sql);  
         
         return $rows;

    }
    public function get_pagosv($idcre) 
    {
        $sql = "SELECT pv.VV_C_CODIGO,pv.VV_N_ABONA,pv.VV_F_FECHA,tp.TPG_D_NOMBRE,pv.PV_I_IMG,pv.VV_D_OBS FROM sm_pagosv pv
INNER JOIN sm_tipospagos tp on tp.TPG_C_CODIGO=pv.TPG_C_CODIGO  where pv.CV_C_CODIGO='$idcre';";
         $rows=$this->db->query($sql);  
         
         return $rows;

    }
    public function get_pagosc($idcre) 
    {
        $sql = "SELECT c.PC_C_CODIGO,c.PC_N_ABONA,c.PC_F_FECHA,tp.TPG_D_NOMBRE,c.PC_D_OBS,c.PC_I_IMG,(CASE c.PC_N_MONEDA WHEN 'Dolares' then '$. ' else 'S/. ' end) as MONEDA FROM sm_pagosc c
INNER JOIN sm_tipospagos tp on tp.TPG_C_CODIGO=c.TPG_C_CODIGO where c.CC_C_CODIGO='$idcre';";
         $rows=$this->db->query($sql);  
         
         return $rows;

    }
     public function get_ventas($idcre) 
    {
        $sql = "SELECT * FROM sm_pagosv  where CV_C_CODIGO='$idcre';";
         $rows=$this->db->query($sql);  
         
         return $rows;

    }
     public function finalizarcreditocompra($idcre,$us) 
    {
      echo  $sql = "call spt_finalizar_cuentascompras('$idcre','$us')";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
    public function finalizar($idcre,$us) 
    {
        $sql = "call spt_finalizar_cuentasventas('$idcre','$us')";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
     public function agregaserie($iddped,$idped,$us,$serie) 
    {
        $sql = "call sta_despachoproductos('$iddped','$idped','$us','$serie')";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
}