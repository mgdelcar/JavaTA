import java.util.*;

class Sample4
{
	public static void main(String[] args)
	{
		Scanner console = new Scanner (System.in);
		
		while (console.hasNextLine())
		{
			String line = console.nextLine();
			
			if (line.equals("Prueba 1"))
			{
				System.out.println("Salida 2");
			}
			else if (line.equals("Test A"))
			{
				System.out.println("Test B");
			}
			else
			{
				System.out.println("Hello World");
			}
		}
	}
}