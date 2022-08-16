// ConsoleApplication1.cpp : Diese Datei enthält die Funktion "main". Hier beginnt und endet die Ausführung des Programms.
//

#include <iostream>
#include <string>

/** Bla tt Klasse
* 
* Blaaaatt Klasse ist Klasse
*/
class Blatt {
    /** zahl i
    *
    * i lang
    */
    int Zahl;
public:
    /** drcken kurz
    * 
    * druckdrucklang
    */
    void Drucken();
    /**Setze was
    * 
    * @param i zahl zu setzen
    */
    void SetzeZahl(int i);
};

int main()
{
    std::cout << "Hello World!\n";
    Blatt meinBlatt{};
    meinBlatt.SetzeZahl(5);
    meinBlatt.Drucken();
}

void Blatt::Drucken()
{
    std::cout << "Blatt!" + std::to_string(Zahl) ;
}

void Blatt::SetzeZahl(int i)
{
    Zahl = i;
}
