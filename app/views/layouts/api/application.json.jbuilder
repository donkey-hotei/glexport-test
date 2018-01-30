json.merge! JSON.parse(yield)
json.errors flatten_errors(@errors) if @errors.present?
