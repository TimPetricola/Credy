# Credy

A simple credit card generator.

## Functionnalities
* Generates a valid number (per country/type)
* Get information for a number
* Check validity of a number

## Installation

`gem install credy`

## CLI usage

`credy generate --country au --type visa`

`credy infos 5108756163954799`

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

### Validates
*Only a few credit card are supported at the moment, if you need this functionnality, use the details and not the global result.*
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
* Add more card types & countries
* More documentation for CLI options