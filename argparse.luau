


local ParserBase = {}


type Option<T> = { __t:T, getValue:(self:Option<T>)->T }
type OptionFn = <T>(T)->Option<T>
local Option = function()end :: OptionFn

type Parser = {}
type ParserFn = <T>(T)->T&Parser
local Parser = function()end :: ParserFn

local TString:string = ""

type Custom = CustomOption{}
local TCustom:Custom = {
    Handle = function(rawval)
        return tonumber(rawval)
    end
}

local p = Parser {
    count = Option(TString);
    test = Option(TCustom)
        :ForCommand("somecommand","ofsubcommand");
}

p.count