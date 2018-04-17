<?php 
require('fpdf.php'); 

function left($str, $length) {
     return substr($str, 0, $length);
}

function right($str, $length) {
     return substr($str, -$length);
}





//Creaci贸n del objeto de la clase heredada 
//$pdf = new PDF('L','mm','LETTER'); 
$pdf =& new FPDF('P', 'mm', array(76, 150));
$pdf->AliasNbPages('TPAG'); 
$pdf->SetTopMargin(1); 
$pdf->SetLeftMargin(7); 
$pdf->SetRightMargin(5); 
$pdf->AddPage(); 
$pdf->Header();

date_default_timezone_set("America/Lima");

//Aqui te conectas a la base de datos, esta pagina no te la doy porque ya la debes tener si trabajas con php y mysql 

require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ventas/ventas.php"); 

 $id=$_REQUEST['q'];

//Aqui haces el llamado a la trabla de tu base de datos 

	  $pdf->SetFont('Arial','B',14); 
        $pdf->Cell(0,5,"GYREY S.A.C ",'',1,'C'); 
		 $pdf->SetFont('Arial','B',10); 
         $pdf->Cell(0,5,"Meza Redonda 3005 3o Piso LIMA",'',1,'C'); 
		 $pdf->SetFont('Arial','B',11); 
         $pdf->Cell(0,5,"945259425 / 949684193",'',1,'C'); 
         $pdf->Ln(1);
		
$p = new Ventas();
 $result=$p->get_idventa($id); 
 

$pdf->SetFont('Arial','B',11); 
$pdf->Cell(0,5,"FACTURA",'',1,'C'); 
$pdf->SetFont('Arial','B',12); 
$pdf->Cell(0,5,"No:". right("0000000011".$result['VEN_V_NUMERO'], 8),'',1,'C'); 
$pdf->Ln(2);
$pdf->SetFont('Arial','B',11); 
$pdf->Cell(69,0,'Senor(es): '.$result['VEN_C_NOMBRECLIENTE'],'I');
 $pdf->Ln(2);
 $pdf->SetFont('Arial','B',12); 
 $pdf->Cell(0,5,"Fecha: ".date('d -m -Y H:i:s')."  ",'',1,'I'); 
 $pdf->Ln(1);
 $pdf->Cell(66,0,'=========================================','',1,'I');
 $pdf->Ln(0);



$pdf->SetFont('Arial','B',10); 
$pdf->Cell(7,6,'Can.','',0,'I'); 
$pdf->SetFont('Arial','B',9); 
$pdf->Cell(35,6,'Nomb.','',0,'C'); 
$pdf->SetFont('Arial','B',10); 
$pdf->Cell(11,6,'P.Uni','',0,'I'); 
$pdf->SetFont('Arial','B',10); 
$pdf->Cell(14,6,'S_Tot','',1,'I');
 
(Double)$total=0;
$d= new Ventas();
 $row=$d->get_detalleventa($result[0]); 

 while($fila=$row->fetch_array()){  
     
    // Aqui empiezas a mostrar los datos 

$cant=intval( $fila[2]);
$pdf->SetFont('Arial','',10); 
 
$pdf->Cell(7,5,$cant,'',0,'C'); 

$pdf->SetFont('Arial','',9); 
$pdf->Cell(35,5,$fila[1],'',0,'Q'); 
$pdf->SetFont('Arial','',9);     
(double)$pre=$fila[3];
$pdf->Cell(11,5,$pre,'',0,'Q'); 
$pdf->SetFont('Arial','',10); 
  (Double)$st= $fila[4];
$pdf->Cell(14,5,$st,'',1,'Q'); 
$total=$total+$fila[4];
	}
$pdf->Ln(1);
 $pdf->Cell(66,0,'=============================================','',1,'I');
 	
 $pdf->Ln(3);
 $pdf->SetFont('Arial','',14);
 $pdf->Cell(60,4,'Total:S/. '.$total,'',1,'R');
$pdf->Ln(2); 
$pdf->SetFont('Arial','BI',10); 
$pdf->Cell(60,2,'www.perucell.com','',1,'C'); 
$pdf->OutPut("Reporte_de_produtos.pdf",'I'); 

?>