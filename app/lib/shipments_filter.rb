class ShipmentsFilter
  def initialize(params)
    @params = params
  end

  def filter(shipments)
    shipments = filter_by_transport_type(shipments)
  end

  private

  def filter_by_transport_type(shipments)
    return shipments if @params[:transport_type].blank?
    shipments.where(transport_type: @params[:transport_type])
  end
end
