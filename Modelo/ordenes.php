<?php

class Ordenes {

private $db;

public function __construct() 
{
        
         $this->db = new Conexion();
       
}
   public function get_saveorden($idus) 
{
        $sql = "call sp_nueva_orden('$idus')";
        
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
      
    }

public function get_deleteorden($idord,$idus) 
{
        $sql = "call sp_deleteorden('$idord','$idus')";
        
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
      
    } 
     public function get_cliorden($idcli,$idor) 
{
        $sql = "call sp_cliente_orden('$idcli','$idor')";
        
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
      
    } 
   
public function get_allordenes($idus) 
{
        $sql = "SELECT o.ORD_C_CODIGO,CONCAT(c.CLI_D_NOMBRE,' ',c.CLI_D_APELLIDOS) AS NOMBRE,o.ORD_C_TIPODOC,(SELECT SUM(do.DTL_N_IMPORTE) FROM sm_detordenes do where do.ORD_C_CODIGO=o.ORD_C_CODIGO) AS TOTAL FROM sm_ordenes o 
inner join sm_cliente c on c.CLI_C_CODIGO=o.CLI_C_CODIGO where o.ORD_E_ESTADO=1 AND o.AUD_C_USUCREA='$idus'";
        
       $rows=$this->db->query($sql);  
           
        return $rows;
      
    }
}

?>