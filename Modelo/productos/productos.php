
<?php 
class Productos {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}
	public function save_producto($nombre ,$modelo ,$descripcion ,$img ,$categoria ,$marca ,$idus,$idsede,$prev) 
{
      
       
      $sql = "CALL sp_save_producto('$nombre ','$modelo ','$descripcion ','$img ','$categoria ','$marca ','$idus','$idsede','$prev');";
        
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
        
        
    }

  public function update_producto($nombre ,$modelo ,$descripcion ,$img ,$categoria ,$marca ,$idus,$idsede,$idpro,$prev) 
{
      $sql = "CALL sp_update_producto('$nombre ','$modelo ','$descripcion ','$img ','$categoria ','$marca ','$idus','$idsede','$idpro','$prev');";
        
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
       
    }
     public function delete_producto($idpro,$us) 
{
      $sql = "CALL sp_delete_producto('$idpro','$us');";
        
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
       
    }
  

    public function get_allProductos($sql) 
    { 
      $rows=$this->db->query($sql);  
        return $rows;
    }
  

    public function get_nomProductos($idus,$idpro) 
    {
    
         $sql = "SELECT * FROM sm_productos where PRO_D_NOMBRE LIKE '$idpro%' AND AUD_U_USARIOCREA='$idus' AND PRO_N_CANTIDAD>0 limit 5";
         $rows=$this->db->query($sql);  
        return $rows;
     
    }
public function get_productos($txt,$sed) 
    {
                $sql="SELECT p.PRO_C_CODIGO,p.PRO_D_NOMBRE,ifnull(dp.PRO_N_PRECIOCOMPRA,0) as PRO_N_PRECIOCOMPRA,ifnull(dp.PRO_N_STOCK,0) as PRO_N_CANTIDAD ,ifnull(dp.PRO_N_PRECIOVENTA,0) as PRO_N_PRECIOVENTA FROM sm_productos p INNER join sm_detalleproductos dp on dp.PRO_C_CODIGO=p.PRO_C_CODIGO  WHERE dp.PRO_N_STOCK>0 AND p.PRO_D_NOMBRE LIKE '".$txt."%' AND dp.SED_C_CODIGO='$sed' LIMIT 12; ";
                $rows=$this->db->query($sql);  
                return $rows;
    }
    public function get_productos_compras($txt,$sed) 
    {
                $sql="SELECT PRO_C_CODIGO,PRO_D_NOMBRE,PRO_N_PRECIOCOMPRA,PRO_N_CANTIDAD,PRO_N_PRECIOVENTA FROM sm_productos WHERE  PRO_D_NOMBRE LIKE '".$txt."%' AND SED_C_CODIGO='$sed' LIMIT 12; ";
                $rows=$this->db->query($sql);  
                return $rows;
    }

public function get_productosc($txt,$sed) 
    {
                $sql="SELECT PRO_C_CODIGO,PRO_D_NOMBRE,ifnull(PRO_N_PRECIOCOMPRA,0) as PRO_N_PRECIOCOMPRA,ifnull(PRO_N_CANTIDAD,0) as PRO_N_CANTIDAD,PRO_N_PRECIOVENTA FROM sm_productos WHERE  PRO_D_NOMBRE LIKE '".$txt."%' AND SED_C_CODIGO='$sed' AND PRO_E_ESTADO>0 LIMIT 12; ";
                $rows=$this->db->query($sql);  
                return $rows;
    }

}
?>