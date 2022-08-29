import enum
from lib2to3.pgen2 import grammar
import string,os
from pypeg2 import *

my_file = os.path.realpath(__file__) # Welcher File wird gerade durchlaufen
my_dir = os.path.dirname(my_file)
projekt_dir = os.path.normpath(os.path. os.path.join(my_dir, '..', '..'))

############################### Keywords ################################
class Section(Keyword):
    grammar = Enum( K("unit"), K("interface"), K("implementation"), K("end") )

class Interface_Keys(Keyword):
    grammar = Enum( K("uses"), K("type") )

class Type_Keys(Keyword):
    grammar = Enum( K("class"), K("record"), K("array") )

class CodeLine(str):
    #  grammar = -2,word, ";",endl
     grammar = restline

class CodeLines(List):
     grammar = maybe_some(CodeLine)

class DokString(str):
     grammar = "///", restline
     
class DokStrings(List):
     grammar = maybe_some(DokString)
     
class Function(List):
     grammar = "function", name()
            #  "(", attr("parms", Parameters), ")", block 

class Implementation(str):
    grammar = CodeLines,attr("section", Section)

class End(str):
    grammar = "end."

class Unit(List):
    grammar = attr('Dok',DokStrings),attr("section", Section),name(),";"

class Use(str):
    grammar = re.compile('[\w\.]*')

class Uses(List):
    grammar = "uses",csl(Use),";"

class Comment(str):
    # grammar =  "//",re.compile('[.^/]'),restline
    grammar =  "//",restline

class VarDekl(List):
    grammar =  attr('Dok',DokStrings),ignore(maybe_some(Comment)), name(), ":", attr("Typ", Symbol) ,";"

class Klasse(List):
    grammar =  attr('Dok',DokStrings), name(), "=","class",optional("(",attr("Ahne", Symbol),")"), \
        maybe_some(VarDekl),maybe_some(Comment), optional("end"),";"
        # maybe_some(attr('Var',VarDekl)), optional("end"),";"
        
class Klassen(List):
    grammar =  maybe_some(Klasse)
    
class Typ_Statements(List):
    grammar = "type",attr("Klassen",Klasse)

class Interface(List):
    grammar = "interface",attr("uses", Uses),maybe_some(Typ_Statements)
        
class All(List):
    grammar =  attr("unit", Unit),attr("interface", Interface),End
 
def handle_file(fname):
    pas_file = os.path.join(projekt_dir, fname )
    with open(pas_file,mode='r', encoding='utf-8') as f:
        # text = f.read().strip()
        text = f.read()
    slash_pos = text.find('//')
    text= text[1:]
    # text = "uses  System.SysUtils, System.Dateutils, Vcl.Controls, Vcl.Dialogs,\n Windows;"
    erg = parse(text,All)
    IF = erg.interface
    print(erg.unit.name)
    pass

fname = 'XAuswerten.pas'
handle_file(fname)
pass