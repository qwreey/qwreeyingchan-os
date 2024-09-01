local toml = createParser {

    -- [server.some.property]
    indexParser = createParser {
        -- . 을 만나면 지금 이름을 리스트에 넣습니다.
        -- 이름이 비어있으면 [.] 와 같은 상황이므로 오류를 발생시킵니다
        "%.", function(self,str,pos,startAt,endAt)
            if not self.indexName then
                error("이름이 비어있음")
            end
            table.insert(self.indexList,self.indexName)
            self.indexName = nil
            return endAt+1,false
        end;
        -- "\\]", 이렇게 이스케이프를 위에 두어 우선순위를 부여 가능함
        -- ] 를 만나면 종료함
        "%]", function(self,str,pos,startAt,endAt)
            return endAt+1,true
        end;
        -- 공백은 무시함
        "%s", function(self,str,pos,startAt,endAt)
        end;
        -- 스캔하다 남은 모든것
        orphans = function(self,str)
            if self.indexName then
                error("인덱스 이름에 띄어쓰기는 금지됨")
            end
            self.indexName = str
        end;
        init = function(self)
            self.indexName = nil
            self.indexList = {}
        end;
        stop = function (self)
            return self.indexList
        end;
    };
    "%[", function (self, str, pos, startAt, endAt, key)
        -- match [
        local parseEndAt
        self.index,parseEndAt = self.indexParser(str)
        return parseEndAt+1
    end;
}