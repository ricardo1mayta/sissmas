<?php

class Pedidos {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}
	//funcion 	que guarda los pedidos
	public function save_pedido($idcli,$us,$sed) 
    {
        $sql = "call spt_save_pedido('$idcli','$us','$sed');";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
    public function delete_pedido($idped,$us) 
    {
         $sql = "call spt_delete_pedido('$idped','$us');";
         $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }
//funcion que permite listar las empresas cliente en la vista pedidos
     public function get_empresasclientes($txt,$us) 
    {
         $sql = "SELECT e.EMP_C_CODIGO,e.EMP_C_RUC,e.EMP_D_RAZONSOCIAL,(SELECT DIRE_D_DESCRIPCION from dg_direccionesempresa where EMP_C_CODIGO=e.EMP_C_CODIGO and DIRE_T_TIPO=1 LIMIT 1) as DIRECCION FROM dg_cartera c 
INNER JOIN dg_empresas e on c.EMP_C_CODIGO=e.EMP_C_CODIGO WHERE c.US_C_CODIGO='$us' AND e.EMP_E_ESTADO>0 
and concat(e.EMP_C_RUC,' ',e.EMP_D_RAZONSOCIAL,' ',e.EMP_D_NOMBRECOMERCIAL) LIKE '%".$txt."%' GROUP BY e.EMP_C_CODIGO ;";
         $rows=$this->db->query($sql);  
        return $rows;

    }

    // Este metodo para listar productos en la vista pedidos
     
     public function get_pedidos($idsede) 
    {
                $sql="SELECT p.PED_C_CODIGO,concat(c.CLI_D_NOMBRE,' ',c.CLI_D_APELLIDOS) AS CLIENTE,c.CLI_D_DOC,
(SELECT SUM(DPED_N_CANTIDAD*DPED_N_PRECIO)  FROM sm_detallepedidos WHERE PED_C_CODIGO=p.PED_C_CODIGO AND DPED_E_ESTADO>0) TOTAL
 FROM sm_pedidos p LEFT JOIN sm_cliente c ON p.CLI_C_CODIGO=c.CLI_C_CODIGO WHERE p.SED_D_CODIGO='$idsede' AND p.PED_E_ESTADO=1;";
                $rows=$this->db->query($sql);  
                return $rows;

    }
    public function get_pedidos_cobranzas($us) 
    {
                $sql="SELECT p.PED_C_CODIGO,c.EMP_D_RAZONSOCIAL,c.EMP_C_RUC,(SELECT SUM(DPE_N_CANTIDAD*DPE_N_PRECIO) FROM dg_detallepedidos where PED_C_CODIGO=p.PED_C_CODIGO) AS TOTAL from dg_pedidos p
INNER JOIN dg_empresas c on c.EMP_C_CODIGO=p.EMP_C_CODIGO where  p.PED_E_ESTADO=3; ";
                $rows=$this->db->query($sql);  
                return $rows;

    }
     public function get_pedidos_validar($us) 
    {
                $sql="SELECT p.PED_C_CODIGO,c.EMP_D_RAZONSOCIAL,c.EMP_C_RUC,(SELECT SUM(DPE_N_CANTIDAD*DPE_N_PRECIO) FROM dg_detallepedidos where PED_C_CODIGO=p.PED_C_CODIGO) AS TOTAL from dg_pedidos p
INNER JOIN dg_empresas c on c.EMP_C_CODIGO=p.EMP_C_CODIGO where   p.PED_E_ESTADO=1; ";
                $rows=$this->db->query($sql);  
                return $rows;

    }
public function validar_pedidos($ped,$us,$e,$obs) 
    {
                $sql="call spv_validar_pedido('$ped','$us','$e','$obs');";
                $rows=$this->db->query($sql); 
                 $result=$rows->fetch_array(); 
                return $result;

    }

}
?>