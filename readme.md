# Credy

A simple credit card generator.

## Functionnalities
* Generates a valid number (per country/type)
* Get information for a number

## Installation

`gem install credy`

## CLI usage

`credy generate --country au --type visa`

`credy validate 5108756163954799`

## Ruby usage

``` ruby
options {
  :country => 'au',
  :type    => 'mastercard'
}
Credy::CreditCard.generate options
```

``` ruby
Credy::CreditCard.validate '5108756163954799'
```

## Supporter cards

At the moment, only a few types and countries are supported.

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