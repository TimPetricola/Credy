# Credy

A simple credit card generator.

## Functionnalities
* Generates a valid number (per country/type)
* Get information for a number
* Check validity of a number

## Installation

`gem install credy`

## CLI usage

### Generate
```
credy generate --country au --type visa
```

### Get informations
`credy infos 5108756163954799`

### Validate
```
Credy::CreditCard.validate '5108756163954799'
```

## Ruby usage

### Generate
``` ruby
options {
  :country => 'au',
  :type    => 'mastercard'
}
Credy::CreditCard.generate options
```

### Get informations
``` ruby
Credy::CreditCard.infos '5108756163954799'
```

### Validate
``` ruby
Credy::CreditCard.validate '5108756163954799'
```

## Supporter cards

At the moment, only a few types and countries are (partially) supported.

### Types
* americanexpress (American Express)
* mastercard (Mastercard)
* visa (Visa)

### Countries
* au (Australia)
* ca (Canada)
* fr (France)
* pl (Poland)
* es (Spain)
* ch (Switzerland)
* uk (United Kingdom)
* us (United States)

## Todo
* Add more data (see the Data source section)

## Data source
All data is coming from the [Bank card number](http://en.wikipedia.org/wiki/Bank_card_number) page and the [List of Issuer Identification Numbers](http://en.wikipedia.org/wiki/List_of_Issuer_Identification_Numbers) on [Wikipedia](http://wikipedia.org). I do not assume the responsibility for wrong data.

## License
Credy is released under the [MIT License](http://opensource.org/licenses/MIT).