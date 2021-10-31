package projeto_agenda;

/**

	References for colors:
	http://stackoverflow.com/questions/1448858/how-to-color-system-out-println-output
	
	x 3 fontcolor 4 backgroundcolor
	y
	0 black
	1 red
	2 green
	3 yellow
	4 blue
	5 magenta
	6 cyan
	7 white 
**/

public class Lanterna{

	private boolean estado;
	
	public Lanterna(){
		estado = false; 
		System.out.println((char)27 + "[37;0m"); // Fundo preto, letra branco.
	}

	public void ComutaEstado(){
		if(estado){
			estado = false;
		}
		else{
			estado = true;
		}
	}

	
	public String toString(){
		String mensagem = "A lanterna está ";
		if(estado){
			mensagem = mensagem + "ligada.\n";
			// System.out.println((char)27 + "[30;47m");
			// Fundo preto, letra verde, brilhante
			System.out.println((char)27 + "[32;1m");
		}
		else{
			mensagem = mensagem + "desligada.\n";
			// System.out.println((char)27 + "[37;40m");
			// Fundo preto, letra branca, desliga todas as formatações
			System.out.println((char)27 + "[37;0m");
		}
		return mensagem;
	} 
}

