<?php

class Ventas {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}
	//funcion 	que guarda los pedidos
	public function save_venta($idped,$op,$us,$sed) 
    {
        $sql = "call spt_save_venta('$idped','$op','$us','$sed')";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
    public function anular_venta($idped,$us,$obs) 
    {
        $sql = "call spt_anular_venta('$idped','$us','$obs')";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
     public function imprimir($idped,$us,$obs) 
    {
        $sql = "call spt_anular_venta('$idped','$us','$obs')";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
    public function cobrar($idped,$us,$tp) 
    {
         $sql = "call spt_cobrar_venta('$idped','$us','$tp')";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
    public function credito($idped,$us,$fv) 
    {
         $sql = "call spt_credito_venta('$idped','$us','$fv')";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
    
     public function get_ventas($idsede) 
    {
                $sql="SELECT * FROM sm_ventas WHERE SED_C_CODIGO='$idsede' ;";
                $rows=$this->db->query($sql);  
                return $rows;

    }
     public function get_ventastipo($idsede,$tipo) 
    {
               $sql="SELECT * FROM sm_ventas WHERE SED_C_CODIGO='$idsede' and VEN_V_TIPO='$tipo' and VEN_E_ESTADO=1 ORDER BY VEN_F_FECHAVENTA DESC;";
                $rows=$this->db->query($sql);  
                return $rows;

    }
     public function get_ventastiporeporte($idsede,$tipo,$l) 
    {
                $sql="SELECT *,(CASE VEN_E_ESTADO WHEN 1 THEN '<b class=text-blue>En Proceso</b>' WHEN 2 then '<b class=text-red>Credito</b>' when 3 then '<b class=text-green>Cancelada</b>' end) as ESTADO FROM sm_ventas WHERE SED_C_CODIGO='$idsede' and VEN_V_TIPO='$tipo' and VEN_E_ESTADO>0 ORDER BY VEN_F_FECHAVENTA DESC limit $l;";
                $rows=$this->db->query($sql);  
                return $rows;

    }
    public function get_idventa($idped) 
    {
                $sql="SELECT * FROM sm_ventas WHERE VEN_C_CODIGO='$idped';";
                $rows=$this->db->query($sql);  
                return $rows;
    }
    public function get_detalleventa($idvent) 
    {
                $sql="SELECT * FROM sm_detalleventas WHERE VEN_C_CODIGO='$idvent' ;";
               $rows=$this->db->query($sql);  
                return $rows;
    }
    public function get_ventastipodespacho($idsede,$tipo) 
    {
               echo $sql="SELECT * FROM sm_ventas WHERE SED_C_CODIGO='$idsede' and VEN_V_TIPO='$tipo' and VEN_E_ESTADO>=1 and VEN_E_ESTADODESPACHO=0 ORDER BY VEN_F_FECHAVENTA DESC;";
                $rows=$this->db->query($sql);  
                return $rows;
    } 

    public function get_serieventa($sed,$text){
   $sql = "select dp.DES_C_SERIE,p.AUD_F_FECHAINSERCION,c.CLI_D_NOMBRE,CLI_D_APELLIDOS,
(CASE p.PED_E_ESTADO WHEN 1 THEN 'EN PROCESO' WHEN 2 THEN 'CREDITO' WHEN 3 THEN 'CANCELADO' END) AS ESTADO,
pr.PRO_D_NOMBRE from sm_despachoproductos dp 
inner join sm_pedidos p on p.PED_C_CODIGO=dp.PED_C_CODIGO
inner join sm_detallepedidos dpe on dpe.PED_C_CODIGO=p.PED_C_CODIGO
inner join sm_productos pr on pr.PRO_C_CODIGO=dpe.PRO_C_CODIGO
inner JOIN sm_cliente c ON c.CLI_C_CODIGO=p.CLI_C_CODIGO
WHERE  dp.DES_C_SERIE ='$text' and p.SED_D_CODIGO='$sed' limit 10;";
 $rows=$this->db->query($sql);  
                return $rows;
    }

   public function update_precio_detalleventa($iddev,$pre,$us){

        $sql = "call spt_edit_precioventafac($iddev,$pre,$us);";
        $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
        return $result;   
   }
    public function update_cantidad_detalleventa($iddev,$pre,$us){

        $sql = "call spt_edit_cantidadventafac($iddev,$pre,$us);";
        $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
        return $result;   
}

}

?>