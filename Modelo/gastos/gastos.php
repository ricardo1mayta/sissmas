<?php

class Gastos {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}
	//funcion 	que guarda los pedidos
	
    public function get_tiposgastos() 
    {
        $sql = "SELECT * FROM sm_tipogastos";
         $rows=$this->db->query($sql);  
         
         return $rows;

    }
     public function get_gastos($idsed) 
    {
       echo $sql = "SELECT * FROM sm_gastos g inner join sm_tipogastos tg on tg.TGA_C_CODIGO=g.TGA_C_CODIGO WHERE g.SED_C_CODIGO=sede('$idsed') and date(g.GAS_F_CREA)=date(ahora());";
         $rows=$this->db->query($sql);           
         return $rows;

    }
    public function save_gastos($tg,$monto,$descri,$us,$sed) 
    {
        $sql = "call spa_save_gastos('$tg','$monto','$descri','$us','$sed')";
        $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
         return $result;

    }


     
}