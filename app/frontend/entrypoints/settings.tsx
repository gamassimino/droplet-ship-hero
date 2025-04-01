import React from 'react';
import { createRoot } from 'react-dom/client';
import JsonEditor from "~/components/JsonEditor";

const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') as string;
const rootElement = document.getElementById('root-element');
const settingId = rootElement?.dataset.id as string;
const schema = JSON.parse(rootElement?.dataset.schema as string);
const initialData = JSON.parse(rootElement?.dataset.initialData as string);
const indexUrl = rootElement?.dataset.indexUrl as string;
const onSubmit = ({ formData }: { formData: any }) => {
  console.log(formData);
  fetch(`/admin/settings/${settingId}`, {
    method: 'PUT',
    body: JSON.stringify({ setting: { values: formData } }),
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': csrfToken as string,
    },
  }).then((response) => {
    if (response.ok) window.location.href = indexUrl;
  });
};
const root = createRoot(rootElement as HTMLElement);

root.render(<JsonEditor schema={schema} initialData={initialData} cancelUrl={indexUrl} onSubmit={onSubmit} />);
