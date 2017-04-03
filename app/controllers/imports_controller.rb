class ImportsController < ApplicationController
  expose(:import_results) do
    Import.order('created_at desc').map(&ImportResult.method(:new))
  end
  expose(:import)
  expose(:import_result) { ImportResult.new(import) }
  expose(:imports) { Import.order(id: :desc) }

  def create
    if import.save
      import.parse
      redirect_to import_path(import)
    else
      render :new
    end
  end

  private

  def import_params
    defaults = {
      state: ImportMicroMachine::UNSTARTED,
      transformer: CsvTransformer
    }
    permitted = %i(description source_id uri)
    params.require(:import).permit(permitted).merge(defaults)
  end
end
