module Megap where

import           Data.Void (Void)
import           Text.Megaparsec
import           Text.Megaparsec.Char
import           Text.Megaparsec.Char.Lexer as L
import           Stack 

----------------------------------------------------------------------------------------------
-- W3.3 A parser for stack programs
-- defined here is the data type for Block, Instrs, Simple and Ctrl

data Block = Blo Instrs deriving Show  
data Instrs= I Simple Instrs | C Ctrl deriving Show
data Simple= Push Int| Add| Mul| Dup| Swap| Neg | Pop| Over deriving Show
data Ctrl= IfZero Block Block | Loop Block| Halt| Ret deriving Show 

type Parser = Parsec Void String

-- space handler for the parser 
 
ws :: Parser ()
ws = L.space space1 empty empty

sym :: String -> Parser String
sym = symbol ws 

-- reads an integer during parsing
 
int :: Parser Int
int = L.signed ws L.decimal

parseBlock :: Parser Block
parseBlock = Blo <$> (sym "{" *> parseInstrs) <* sym "}"

parseInstrs:: Parser Instrs 
parseInstrs =     I <$> (parseSimple <* sym ";") <*> parseInstrs
              <|> C <$> parseCtrl
              

parseSimple:: Parser Simple
parseSimple =     Megap.Push <$> (sym "push " *> int)
              <|> Megap.Add  <$  sym "add"
              <|> Megap.Mul  <$  sym "mul"
              <|> Megap.Dup  <$  sym "dup"           
              <|> Megap.Swap <$  sym "swap"
              <|> Megap.Neg  <$ sym "neg"
              <|> Megap.Pop  <$ sym "pop"
              <|> Megap.Over <$ sym "over"
              
              
parseCtrl :: Parser Ctrl
parseCtrl = Megap.Halt <$ sym "halt"
            <|> Megap.IfZero <$> (sym "ifzero" *> parseBlock) <*> parseBlock
            <|> Megap.Loop <$> (sym "loop" *> parseBlock)       
            <|> Ret <$ sym "ret"

-- Read a string from file and parse value to the function run that is defined in Stack.hs 
          
main ::FilePath -> IO (Maybe[Int])
main file= do 
    x<- readFile file
    case parse parseBlock file x of
        Left bundle -> putStr (errorBundlePretty bundle) >> return Nothing
        Right b -> return $ run (fromBlock b)
            
-- these function take a Block,Instrs,Ctrl and simple and returns an Instructions 
-- so that we can run them through our Run function in Stack.hs  
         
fromBlock :: Block -> Instructions
fromBlock  b = fromBlock' b Stack.Halt

fromBlock' :: Block -> Instructions -> Instructions
fromBlock'(Blo x) ret = fromInstrs x ret

fromInstrs :: Instrs ->  Instructions-> Instructions
fromInstrs (I a b) ret = fromSimple a (fromInstrs b ret) 
fromInstrs (C c)   ret = fromCtrl c ret


fromSimple :: Simple -> Instructions -> Instructions
fromSimple Megap.Pop      cont = Stack.Pop cont
fromSimple (Megap.Push i) cont = Stack.Push i cont
fromSimple Megap.Add      cont = Stack.Add cont
fromSimple Megap.Mul      cont = Stack.Mul cont
fromSimple Megap.Dup      cont = Stack.Dup cont
fromSimple Megap.Swap     cont = Stack.Swap cont
fromSimple Megap.Neg      cont = Stack.Neg cont
fromSimple Megap.Over     cont = Stack.Over cont  


fromCtrl :: Ctrl -> Instructions -> Instructions
fromCtrl (Megap.Halt)        _    = Stack.Halt
fromCtrl Ret                 ret  = ret
fromCtrl l@(Megap.Loop b)     _   = Stack.Loop $ \loop ->fromBlock' b loop
fromCtrl (Megap.IfZero b1 b2) ret = Stack.IfZero( fromBlock' b1 ret) ( fromBlock' b2 ret)

          
