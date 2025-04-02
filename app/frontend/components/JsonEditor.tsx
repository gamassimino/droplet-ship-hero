import Form from "@rjsf/core";
import { RJSFSchema, TemplatesType, FieldTemplateProps, ObjectFieldTemplateProps, IconButtonProps, SubmitButtonProps, ArrayFieldTemplateProps } from "@rjsf/utils";
import validator from "@rjsf/validator-ajv8";
import React from 'react';

function JsonEditor({ schema, initialData, cancelUrl, onSubmit }: { schema: RJSFSchema, initialData: any, cancelUrl: string, onSubmit: (data: any) => void }) {
  const customTheme: Partial<TemplatesType> = {
    FieldTemplate: (props: FieldTemplateProps) => {
      const { id, label, children, errors, help, required, schema } = props;
      const isArrayItem = id.match(/_\d+$/);
      const isBoolean = schema.type === 'boolean';

      return (
        <div className="flex items-center gap-4 mb-4">
          {!isArrayItem && label && (
            <div className="shrink-0 w-48">
              <label htmlFor={id} className="text-sm font-medium text-gray-700">
                {label}
                {required && <span className="text-orange-600 ml-1">*</span>}
              </label>
            </div>
          )}
          <div className={`${isArrayItem ? 'w-full' : 'w-full'} ${isBoolean ? '' : '[&_input]:w-full [&_input]:p-2 [&_input]:border [&_input]:border-gray-300 [&_input]:rounded-md'} [&_textarea]:w-full [&_textarea]:p-2 [&_textarea]:border [&_textarea]:border-gray-300 [&_textarea]:rounded-md`}>
            {isBoolean ? (
              <input
                type="checkbox"
                id={id}
                checked={props.formData}
                onChange={(e) => props.onChange(e.target.checked)}
                className="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
              />
            ) : (
              children
            )}
            {errors && (
              <div className="mt-1 text-sm text-red-600">
                {errors}
              </div>
            )}
            {help && <div className="mt-1 text-sm text-gray-500">{help}</div>}
          </div>
        </div>
      );
    },
    ObjectFieldTemplate: (props: ObjectFieldTemplateProps) => {
      const { title, description, properties, idSchema } = props;
      // Only show title if it's the root object
      const showTitle = idSchema.$id === 'root' && title;

      return (
        <div className="bg-white p-6 rounded-lg shadow-sm">
          {showTitle && <h3 className="text-lg font-medium mb-4">{title}</h3>}
          {description && <p className="mb-4 text-sm text-gray-500">{description}</p>}
          {properties?.map((prop) => prop.content)}
        </div>
      );
    },
    ButtonTemplates: {
      SubmitButton: (props: SubmitButtonProps) => (
        <div>
          <button
            type="submit"
            className="inline-flex items-center text-sm bg-blue-600 hover:bg-orange-600 text-white px-4 py-2 rounded-md mr-2"
          >
            Update
          </button>
          <a
            href={cancelUrl}
            className="inline-flex items-center text-sm bg-gray-200 hover:bg-gray-300 text-gray-800 px-4 py-2 rounded-md"
          >
            Cancel
          </a>
        </div>
      ),
      AddButton: (props: IconButtonProps) => null,
      CopyButton: (props: IconButtonProps) => null,
      MoveDownButton: (props: IconButtonProps) => null,
      MoveUpButton: (props: IconButtonProps) => null,
      RemoveButton: (props: IconButtonProps) => null
    },
    ArrayFieldTemplate: (props: ArrayFieldTemplateProps) => {
      const { items, canAdd, onAddClick } = props;
      return (
        <div className="mb-4">
          {items.map((item) => (
            <div key={item.key} className="mb-4 p-4 border border-gray-200 rounded-md">
              <div className="flex items-center justify-end mb-2">
                {item.hasRemove && (
                  <button
                    type="button"
                    className="text-sm text-red-600 hover:text-red-700"
                    onClick={item.onDropIndexClick(item.index)}
                  >
                    Remove
                  </button>
                )}
              </div>
              {item.children}
            </div>
          ))}
          <div className="flex items-center justify-between mb-2">
            {canAdd && (
              <button
                type="button"
                className="inline-flex items-center text-sm bg-green-600 hover:bg-green-700 text-white px-3 py-1 rounded-md"
                onClick={onAddClick}
              >
                Add
              </button>
            )}
          </div>
        </div>
      );
    }
  };

  return(
    <Form<any, RJSFSchema, any>
      schema={schema}
      formData={initialData}
      validator={validator}
      templates={customTheme}
      onSubmit={onSubmit}
      liveValidate={true}
      showErrorList={false}
    />
  )
}

export default JsonEditor;