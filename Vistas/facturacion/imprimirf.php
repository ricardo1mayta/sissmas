<?php 
require('fpdf.php'); 

function left($str, $length) {
     return substr($str, 0, $length);
}

function right($str, $length) {
     return substr($str, -$length);
}
function genMonth_Text($m) { 
 switch ($m) { 
  case 1: $month_text = "Enero"; break; 
  case 2: $month_text = "Febrero"; break; 
  case 3: $month_text = "Marzo"; break; 
  case 4: $month_text = "Abril"; break; 
  case 5: $month_text = "Mayo"; break; 
  case 6: $month_text = "Junio"; break; 
  case 7: $month_text = "Julio"; break; 
  case 8: $month_text = "Agosto"; break; 
  case 9: $month_text = "Septiembre"; break; 
  case 10: $month_text = "Octubre"; break; 
  case 11: $month_text = "Noviembre"; break; 
  case 12: $month_text = "Diciembre"; break; 
 } 
 return ($month_text); 
} 



//Creaci贸n del objeto de la clase heredada 
//$pdf = new PDF('L','mm','LETTER'); 
$pdf =& new FPDF('P', 'mm', array(210, 297));
$pdf->AliasNbPages('TPAG'); 
$pdf->SetTopMargin(1); 
$pdf->SetLeftMargin(1); 
$pdf->SetRightMargin(1); 
$pdf->AddPage(); 
$pdf->Header();

date_default_timezone_set("America/Lima");

//Aqui te conectas a la base de datos, esta pagina no te la doy porque ya la debes tener si trabajas con php y mysql 

require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ventas/ventas.php"); 
include("../../Modelo/funciones/numletras.php"); 

 $id=$_REQUEST['q'];

//Aqui haces el llamado a la trabla de tu base de datos 
/*
	  $pdf->SetFont('Arial','B',14); 
        $pdf->Cell(0,5,"GYREY S.A.C ",'',1,'C'); 
		 $pdf->SetFont('Arial','B',10); 
         $pdf->Cell(0,5,"Meza Redonda 3005 3o Piso LIMA",'',1,'C'); 
		 $pdf->SetFont('Arial','B',11); 
         $pdf->Cell(0,5,"945259425 / 949684193",'',1,'C'); 
         $pdf->Ln(1);
		*/
$pdf->Ln(45);
$p = new Ventas();
 $result=$p->get_idventa($id); 
 
/*
$pdf->SetFont('Arial','B',11); 
$pdf->Cell(0,5,"FACTURA",'',1,'C'); 
$pdf->SetFont('Arial','B',12); 
$pdf->Cell(0,5,"No:". right("0000000011".$result['VEN_V_NUMERO'], 8),'',1,'C'); 
$pdf->SetFont('Arial','B',12); 
 $pdf->Cell(0,5,"Fecha: ".date('d -m -Y H:i:s')."  ",'',1,'I'); 
*/
$pdf->Cell(10);
$pdf->SetFont('Arial','',12); 
$pdf->Cell(35,5,date('d'),'',0,'B'); 
$pdf->SetFont('Arial','',12);     
$pdf->Cell(11,5,genMonth_Text(date('m')),'',0,'B'); 
$pdf->Cell(25);
$pdf->SetFont('Arial','',12);     
$pdf->Cell(14,5,right(date('Y'),1),'',0,'B'); 


$pdf->Ln(10);
$pdf->SetFont('Arial','B',11); 
$pdf->Cell(13);
$pdf->Cell(69,0,$result['VEN_C_NOMBRECLIENTE'],0,'Q');
$pdf->SetFont('Arial','B',12); 
$pdf->Cell(50);
 $pdf->Cell(30,0,"8488437484848 ",'',0,'Q'); 
 $pdf->Ln(5);
 $pdf->SetFont('Arial','B',11); 
$pdf->Cell(15);
$pdf->Cell(69,0,'Los Olivos','I');
 
 $pdf->Ln(10);
 

/*

$pdf->SetFont('Arial','B',10); 
$pdf->Cell(7,6,'Can.','',0,'I'); 
$pdf->SetFont('Arial','B',9); 
$pdf->Cell(35,6,'Nomb.','',0,'C'); 
$pdf->SetFont('Arial','B',10); 
$pdf->Cell(11,6,'P.Uni','',0,'I'); 
$pdf->SetFont('Arial','B',10); 
$pdf->Cell(14,6,'S_Tot','',1,'I');
 */

(Double)$total=0.00;
$i=50;
$d= new Ventas();
 $row=$d->get_detalleventa($result[0]); 

 while($fila=$row->fetch_array()){  
     
$cant=intval( $fila[2]);
$pdf->SetFont('Arial','',10); 
 
$pdf->Cell(20,5,$cant,'',0,'C'); 

$pdf->SetFont('Arial','',9); 
$pdf->Cell(90,5,$fila[1],'',0,'Q'); 
$pdf->SetFont('Arial','',9);     
(double)$pre=$fila[3];
$pdf->Cell(30,5,'S/. '.number_format($pre, 2, '.', ''),'',0,'R'); 
$pdf->SetFont('Arial','',10); 
  (Double)$st= $fila[4];
$pdf->Cell(30,5,'S/. '.number_format($st, 2, '.', ''),'',1,'R'); 
$total=$total+$fila[4];
$i=$i-5;
	}
$pdf->Ln($i);
 
 $pdf->SetFont('Arial','',11);
 $pdf->Cell(50);
 $pdf->Cell(80,4,convertirnumero(($total-$total*0.18),'',0,'R');
 $pdf->Ln(5);
 $pdf->SetFont('Arial','',10);
 $pdf->Cell(110);
 $pdf->Cell(60,4,'S/. '.number_format(($total*0.18), 2, '.', ''),'',1,'R');
$pdf->Ln(5);
 $pdf->SetFont('Arial','',10);
 $pdf->Cell(110);
 $pdf->Cell(60,4,'S/. '.number_format($total, 2, '.', ''),'',1,'R');
 $pdf->Ln(5);
 $pdf->SetFont('Arial','',10);
 $pdf->Cell(110);
 $pdf->Cell(60,4,'S/. '.number_format($total, 2, '.', ''),'',1,'R');
$pdf->SetFont('Arial','BI',10); 
$pdf->Ln(2); 

$pdf->OutPut("Reporte_de_produtos.pdf",'I'); 

?>