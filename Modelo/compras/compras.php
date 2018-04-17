<?php

class Compras {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}

public function save_compra($idpv ,$us,$idsed,$tipodoc,$num,$tipomoneda,$tipocambio){

		  $sql = "call spt_save_compra('$idpv','$us','$idsed','$tipodoc','$num','$tipomoneda','$tipocambio');";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;
	}
public function get_comprastipodespacho($idsede,$tipo) 
    {
                $sql="SELECT c.C_C_CODIGO,p.PV_D_NOMBRES,c.C_N_NUMDOC,c.T_C_CODIGO,p.PV_C_DOC,p.PV_D_DIRECCION,c.AUD_F_FECHAINSERCION,(SELECT ifnull(SUM(COM_N_CANTIDAD * COM_N_PRECIOC),0)  FROM sm_detallecompras dc 
WHERE dc.C_C_CODIGO=c.C_C_CODIGO and COM_E_ESTADO>0) AS TOTAL,(CASE c.C_N_MONEDA WHEN 'Dolares' then '$. ' else 'S/. ' END) AS MONEDA FROM sm_compra c 
INNER JOIN sm_provedores p on c.PV_C_CODIGO=p.PV_C_CODIGO  WHERE c.SED_C_CODIGO='$idsede' and c.T_C_CODIGO='$tipo' and c.C_E_ESTADO=1  ORDER BY AUD_F_FECHAINSERCION DESC;";
                $rows=$this->db->query($sql);  
                return $rows;
    } 
public function get_comprastiporeporte($idsede,$tipo,$l) 
    {
                $sql="SELECT c.C_C_CODIGO,(case c.C_E_ESTADO when 0 then 'Eliminado' when 1 then 'Activa' when 2 then '<b class=text-red>Credito</b>' WHEN 3 THEN'<b class=text-green>Cancelada</b>' else 'Sin Definir' end ) AS C_E_ESTADO,p.PV_D_NOMBRES,c.C_N_NUMDOC,c.T_C_CODIGO,p.PV_C_DOC,p.PV_D_DIRECCION,c.AUD_F_FECHAINSERCION,(SELECT ifnull(SUM(COM_N_CANTIDAD * COM_N_PRECIOC),0)  FROM sm_detallecompras dc 
WHERE dc.C_C_CODIGO=c.C_C_CODIGO and COM_E_ESTADO>0) AS TOTAL FROM sm_compra c 
INNER JOIN sm_provedores p on c.PV_C_CODIGO=p.PV_C_CODIGO  WHERE c.SED_C_CODIGO='$idsede' and c.T_C_CODIGO='$tipo' and c.C_E_ESTADO>1  ORDER BY AUD_F_FECHAINSERCION DESC limit $l; ";
                $rows=$this->db->query($sql);  
                return $rows;
    } 
public function deuda($idped,$us,$fv) 
    {
       $sql = "call spt_credito_compra('$idped','$us','$fv');";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }

public function pagar($idped,$us,$tipo) 
    {
          $sql = "call spt_pagar_compra('$idped','$us','$tipo')";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
public function get_seriecompras($sed,$text){
   $sql = "select rp.RES_C_SERIE,p.PV_D_NOMBRES,c.AUD_F_FECHAINSERCION,
(CASE c.C_E_ESTADO WHEN 1 THEN  'EN PROCESO' WHEN 2 THEN 'CREDITO' WHEN 3 THEN 'CANCELADO' END) as ESTADO from sm_recepcionproductos rp 
inner join sm_compra c on c.C_C_CODIGO=rp.COM_C_CODIGO
inner join sm_provedores p ON p.PV_C_CODIGO=c.PV_C_CODIGO
WHERE c.SED_C_CODIGO='$sed' AND rp.RES_C_SERIE='$text' limit 10;";
 $rows=$this->db->query($sql);  
                return $rows;
    }
     public function creditocompras($idped,$us) 
    {
         $sql = "call spt_credito_compra('$idped','$us')";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
}

?>

