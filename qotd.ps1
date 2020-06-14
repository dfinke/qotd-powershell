#Requires -Modules Pode
param(
    $address = "*",
    $port = 8081
)

# based on
# https://github.com/DonSchenck/qotd-python

# PowerShell version of Quote Of the Day microservice

$quotes = $(
    @{'id'          = 0;
        'quotation' = '40 is the old age of youth, while 50 is the youth of old age';
        'author'    = 'Victor Hugo'
    }
    @{'id'          = 1;
        'quotation' = 'Knowledge is power.';
        'author'    = 'Francis Bacon'
    }
    @{'id'          = 2;
        'quotation' = 'Life is really simple, but we insist on making it complicated.';
        'author'    = 'Confucius'
    }
    @{'id'          = 3;
        'quotation' = 'This above all, to thine own self be true.';
        'author'    = 'William Shakespeare'
    }
    @{'id'          = 4;
        'quotation' = 'Never complain. Never explain.';
        'author'    = 'Katharine Hepburn'
    }
    @{'id'          = 5;
        'quotation' = 'Do be do be dooo.';
        'author'    = 'Frank Sinatra'
    }
)

Start-PodeServer {

    Set-PodeState -Name quotes -Value $quotes

    Add-PodeEndpoint -Address $address -Port $port -Protocol Http
    
    Add-PodeRoute -Method Get -Path '/' -ScriptBlock { Write-PodeTextResponse -Value "qotd" }

    Add-PodeRoute -Method Get -Path '/version' -ScriptBlock { Write-PodeTextResponse -Value "1.0.0" }

    Add-PodeRoute -Method Get -Path '/writtenin' -ScriptBlock { Write-PodeTextResponse -Value "PowerShell" }

    Add-PodeRoute -Method Get -Path '/quotes' -ScriptBlock { 
        Write-PodeJsonResponse -Value (Get-PodeState -Name quotes)
    }

    Add-PodeRoute -Method Get -Path '/quotes/:id' -ScriptBlock { 
        param($script:event)

        $id = $event.Parameters['id'] 
        $r = (Get-PodeState -Name quotes)[$id]

        Write-PodeJsonResponse -Value $r
    }

    Add-PodeRoute -Method Get -Path '/quotes/random' -ScriptBlock { 
        Write-PodeJsonResponse -Value ((Get-PodeState -Name quotes) | Get-Random)
    }
}